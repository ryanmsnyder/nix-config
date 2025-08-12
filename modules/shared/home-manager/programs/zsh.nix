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
            lf = "lfcd";

            nd = "nix develop --command zsh";

            diff = "difft";
            
            nvim = "env TERM=wezterm nvim";
            vim = "env TERM=wezterm nvim";

        };

        initContent = lib.mkBefore ''
            if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
            fi

            # add brew to path (nix-homebrew doesn't seem to be doing this automatically)
            if [[ $(uname -m) == 'arm64' ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
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
            #alias diff=difft

            # Workaround for lf's limitation of changing the working directory. This changes the working
            # directory to the current directory in lf when lf is quit
            lfcd() {
              cd "$(command lf -print-last-dir "$@")"
            }

            # Bind Ctrl+O to lfcd
            bindkey -s '^o' 'lfcd\n'

            # # Set up fzf key bindings and fuzzy completion
            # source <(fzf --zsh)
            #
            # export FZF_DEFAULT_OPTS="
            #   --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
            #   --color=fg:#cad3f5,header:#f5a97f,info:#c6a0f6,pointer:#f4dbd6
            #   --color=marker:#a6da95,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
            #   --pointer='➜' --marker='✓' --prompt='❯ '
            #   --border
            #   --multi
            #   --reverse
            #   --bind 'ctrl-e:become(nvim {+})'
            #   --bind 'alt-a:select-all'
            #   --bind '?:toggle-preview'
            #   --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (lsd -F --tree --depth 2 --all --color=always --icon=always {} | less)) || echo {} 2> /dev/null | head -200'"
            #
            # # CTRL-Y to copy the command into clipboard using pbcopy
            # export FZF_CTRL_R_OPTS="
            #   --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
            #   --color header:italic
            #   --layout reverse
            #   --header 'Press CTRL-Y to copy command into clipboard'"
            #
            # # Preview file content using bat (https://github.com/sharkdp/bat)
            # export FZF_CTRL_T_OPTS="
            #   --walker-skip .git,node_modules,target
            #   --preview 'bat -n --color=always {}'
            #   --bind 'ctrl-w:change-preview-window(down|hidden|)'
            #   --header 'Press CTRL-W to toggle the preview window between different states'"
        '';
    };
}
