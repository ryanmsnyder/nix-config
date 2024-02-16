{ config, pkgs, lib, ... }:

{
    programs.zsh = {
        # Shared shell configuration
        enable = true;
        autocd = false;
        plugins = [
            {
            # will source zsh-autosuggestions.plugin.zsh
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
                owner = "zsh-users";
                repo = "zsh-autosuggestions";
                rev = "v0.4.0";
                sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
            };
            }
        ];

        syntaxHighlighting = {
            enable = true;
        };

        shellAliases = {
            # lsd
            ls = "lsd";
            l = "ls -l";
            la = "ls -a";
            lla = "ls -la";
            lt = "ls --tree";

            # bat
            cat = "bat";

            # git
            gst = "git status";
            ga = "git add";
            gl = "git log";
            glo = "git log --graph --decorate --oneline";
            gc = "git commit";
            gp = "git push";
            gd = "git diff";
            gunstage = "git reset HEAD --"; # undo git add .
            grestore = "git reset --hard HEAD"; # reset staging area and working directory back to HEAD

            # lf (file manager)
            # lf = "lfcd";
        };

        initExtraFirst = ''
            if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
            fi

            # Define variables for directories
            export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
            export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
            export PATH=$HOME/.local/share/bin:$PATH

            # Remove history data we don't want to see
            export HISTIGNORE="pwd:ls:cd"

            # nix shortcuts
            shell() {
                nix-shell '<nixpkgs>' -A "$1"
            }

            # Use difftastic, syntax-aware diffing
            alias diff=difft

            # Always color ls and group directories
            alias ls='ls --color=auto'
        '';
    };
}