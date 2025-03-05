{ config, pkgs, lib, ... }:
let
  # Create a Python environment with the necessary packages for a custom script
  # that moves items to the trash so they can be restored if needed
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    # required Python packages
    cffi
    pycparser
    xattr
  ]);

  # Define the path to the Python interpreter
  pythonInterpreter = "${pythonEnv}/bin/python";


in
{   
    programs.lf = {
        enable = true;
        settings = {
        # interpreter for shell commands
        shell = "sh";

        # set '-eu' options for shell commands
        # These options are used to have safer shell commands. Option '-e' is used to
        # exit on error and option '-u' is used to give error for unset variables.
        # Option '-f' disables pathname expansion which can be useful when $f, $fs, and
        # $fx variables contain names with '*' or '?' characters. However, this option
        # is used selectively within individual commands as it can be limiting at
        # times.
        shellopts = "-eu";

        # set internal field separator (IFS) to "\n" for shell commands
        # This is useful to automatically split file names in $fs and $fx properly
        # since default file separator used in these variables (i.e. 'filesep' option)
        # is newline. You need to consider the values of these options and create your
        # commands accordingly.
        ifs = "\\n";

        # enable hidden files
        hidden = true;

        # enable icons
        icons = true;

        # leave some space at the top and the bottom of the screen
        scrolloff = 10;

        # Use the `dim` attribute instead of underline for the cursor in the preview pane
        cursorpreviewfmt = "\\033[7;2m";
        };


        commands = {
            # &{{}} syntax is for async/background commands
            # ${{}} syntax is for synchronous commands

            # define a custom 'open' command
            # This command is called when current file is not a directory. You may want to
            # use either file extensions and/or mime types here. Below uses an editor for
            # text files and a file opener for the rest.
            open = ''&{{
                case $(file --mime-type -Lb $f) in
                text/*) lf -remote "send $id \$$EDITOR \$fx";;
                *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
                esac
                }}
                '';
            
            # define a custom 'delete' command
            delete = ''''${{
                set -f
                # printf '"$fx"\n'
                printf 'Move "$fx" to trash? [y/n]: '
                read ans
                [ "$ans" = "y" ] && rm -rf "$fx"
            }}
            '';

            # extract the current file with the right command
            # (xkcd link: https://xkcd.com/1168/)
            extract =  ''''${{
                set -f
                case $f in
                    *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
                    *.tar.gz|*.tgz) tar xzvf $f;;
                    *.tar.xz|*.txz) tar xJvf $f;;
                    *.zip) unzip $f;;
                    *.rar) unrar x $f;;
                    *.7z) 7z x $f;;
                esac
            }}
            '';

            # execute python script that moves the item to the trash so that it can be restored
            trash = ''''${{
                ${pythonInterpreter} "$HOME/.config/lf/move_to_trash/trash.py" $fx
                echo "Moved \033[31m$fx\033[0m to trash.\n"
            }}
            '';

            restore_trash = ''''${{
                printf "Enter each file/directory you'd like to restore separated by a space (only provide file name + extension). Use quotes if the file/directory name contains spaces:\n\033[32m❯\033[0m "
                read -r input
                trash_dir=~/.Trash
                ans=()
                
                # Use eval to split the input into words
                # This will correctly handle words in quotes
                eval "files=( $input )"
                
                for file in "''${files[@]}"; do
                ans+=("''${trash_dir}/''${file}")
                done
                
                # putback "''${ans[@]}" &> /dev/null
                ${pythonInterpreter} "$HOME/.config/lf/move_to_trash/putback.py" "''${ans[@]}" 
                echo "The following files/directories have been restored:\n\033[32m''${ans[@]}\033[0m\n"
            }}
            '';

            # compress current file or selected files with tar and gunzip
            tar = ''''${{
                set -f
                mkdir $1
                cp -r $fx $1
                tar czf $1.tar.gz $1
                rm -rf $1
                }}
            '';

            # compress current file or selected files with zip
            zip = ''''${{
                set -f
                mkdir $1
                cp -r $fx $1
                zip -r $1.zip $1
                rm -rf $1
            }}
            '';

            preview = ''''${{
                qlmanage -p $fx > /dev/null
            }}
            '';
        };
        
        keybindings = {
            # mkdir command. See wiki if you want it to select created dir
            a = ":push %mkdir<space>";

            # Basic Functions
            "." = "set hidden!";
            d = "trash";
            T = "restore_trash";
            y = "copy";
            p = "paste";
            x = "cut";
            "<enter>" = "open";
            r = "rename";
            R = "reload";
            mf = "mkfile";
            md = "mkdir";
            C = "clear";

            # select current item
            "<c-x>" = "toggle";

            # preview file in MacOS qlmanage (QuickLook)
            "<space>" = "preview > /dev/null";

            # set semicolon to enter command mode
            ";" = "push :";

            # use enter for shell commands
            # "<enter>" = "shell";

            # show the result of execution of previous commands
            "`" = "!true";

            # shortcuts to commonly used directories
            c = "cd ~/code";
            gD = "cd ~/documents";
            gd = "cd ~/downloads";
            gc = "cd ~/.config";

            # dedicated keys for file opener actions
            o = "&mimeopen $f";
            O = "$mimeopen --ask $f";

            # set bat as pager
            i = "$bat $f --pager='less -R'";
        };

        extraConfig = ''
            $mkdir -p ~/.trash
            
            set previewer ~/.config/lf/lf_previewer
            set cleaner ~/.config/lf/lf_cleaner
        '';
    };


    # Copy files in modules/shared/config/lf to ~/.config/lf
    # Note: setting the entire config/lf dir as the source would overwrite the lfrc file generated by nix
    # That's why I've set each file individually
    xdg.configFile."lf/icons".source = ../config/lf/icons;
    xdg.configFile."lf/colors".source = ../config/lf/colors;
    xdg.configFile."lf/lf_previewer".source = ../config/lf/lf_previewer;
    xdg.configFile."lf/lf_cleaner".source = ../config/lf/lf_cleaner;
    # symlink entire move_to_trash subdir
    home.file.".config/lf/move_to_trash".source = ../config/lf/move_to_trash; 
}
