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

            nix-switch() {
                local pass=$(security find-generic-password -s "master-password" -a "ryan.snyder" -w 2>/dev/null)
                if [ -z "$pass" ]; then
                    echo "Error: Could not retrieve password from Keychain" >&2
                    return 1
                fi
                local askpass=$(mktemp)
                chmod 700 "$askpass"
                trap "rm -f '$askpass'" EXIT INT TERM
                printf '#!/bin/sh\necho "%s"\n' "$pass" > "$askpass"
                SUDO_ASKPASS="$askpass" nix run "$HOME/nix-config#build-switch"
                rm -f "$askpass"
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

            # ---------------------------------------------------------------------------
            # Git worktree helpers
            # ---------------------------------------------------------------------------

            # cwt <branch> — create a worktree and open it in a new Wezterm workspace.
            # Run from anywhere inside a git repo.
            cwt() {
              if [[ -z "$1" ]]; then
                echo "usage: cwt <branch-name>" >&2
                return 1
              fi

              local BRANCH="$1"
              local REPO
              REPO=$(git rev-parse --show-toplevel 2>/dev/null) || {
                echo "cwt: not inside a git repo" >&2
                return 1
              }

              # Flatten slashes for the filesystem path; keep slashes in the branch name
              local SLUG
              SLUG=$(echo "$BRANCH" | tr '[:upper:]' '[:lower:]' | tr '/' '-' | tr ' ' '-')
              local WT="$REPO/.claude/worktrees/$SLUG"

              if [[ -d "$WT" ]]; then
                echo "cwt: worktree already exists at $WT" >&2
                return 1
              fi

              echo "cwt: creating worktree $WT on branch $BRANCH" >&2
              git -C "$REPO" worktree add -b "$BRANCH" "$WT" || return 1

              # Copy gitignored config files into the new tree
              source "$HOME/.claude/lib/worktree-copy.sh"
              worktree_copy_files "$REPO" "$WT"

              local WS_NAME
              WS_NAME="$(basename "$REPO"):$BRANCH"

              echo "cwt: spawning Wezterm workspace '$WS_NAME'" >&2
              local PANE_ID
              local SHELL_PANE
              SHELL_PANE=$(wezterm cli spawn --new-window --workspace "$WS_NAME" --cwd "$WT" 2>/dev/null)
              wezterm cli split-pane --pane-id "$SHELL_PANE" --left --cwd "$WT" -- claude > /dev/null
            }

            # wt-rm — remove the worktree the current shell is sitting in.
            # Must be run from inside a worktree (not the main repo checkout).
            wt-rm() {
              local WT
              WT=$(git rev-parse --show-toplevel 2>/dev/null) || {
                echo "wt-rm: not inside a git repo" >&2
                return 1
              }

              # Detect that we're actually in a worktree (not the main checkout)
              local GIT_DIR
              GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
              if [[ "$GIT_DIR" == ".git" || "$GIT_DIR" == "$WT/.git" ]]; then
                echo "wt-rm: not in a worktree — refusing to run in the main checkout" >&2
                return 1
              fi

              local BRANCH
              BRANCH=$(git branch --show-current 2>/dev/null || echo "(detached)")

              echo "wt-rm: remove worktree '$WT' (branch: $BRANCH)? [y/N] " >&2
              read -r CONFIRM
              [[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "wt-rm: cancelled" >&2; return 0; }

              # Locate the main checkout (the .git file inside a worktree points to the real repo)
              local REPO
              REPO=$(git -C "$WT" rev-parse --git-common-dir 2>/dev/null)
              REPO=$(dirname "$REPO")

              local DEFAULT
              DEFAULT=$(git -C "$REPO" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo "origin/main")

              local AHEAD=0
              if [[ "$BRANCH" != "(detached)" ]]; then
                AHEAD=$(git -C "$REPO" rev-list --count "''${DEFAULT}..''${BRANCH}" 2>/dev/null || echo 0)
              fi

              local LOG="$HOME/.claude/worktree.log"
              _wt_log() { echo "[$(/bin/date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

              # Step out of the worktree dir before removing it
              cd "$REPO" || cd "$HOME"

              git -C "$REPO" worktree remove --force "$WT" || {
                echo "wt-rm: git worktree remove failed" >&2
                return 1
              }

              if [[ "$BRANCH" != "(detached)" ]]; then
                if [[ "$AHEAD" == "0" ]]; then
                  git -C "$REPO" branch -D "$BRANCH" 2>/dev/null || true
                  _wt_log "REMOVED path=$WT branch=$BRANCH (0 commits ahead of $DEFAULT)"
                  echo "wt-rm: removed worktree and branch '$BRANCH'" >&2
                else
                  _wt_log "REMOVED path=$WT branch=$BRANCH preserved — $AHEAD commit(s) ahead of $DEFAULT"
                  echo "wt-rm: removed worktree; preserved branch '$BRANCH' ($AHEAD commit(s) ahead of $DEFAULT)" >&2
                fi
              else
                _wt_log "REMOVED path=$WT (detached HEAD)"
              fi
            }

            # wt-clean — fzf-driven sweep of stale worktrees across all ~/Code repos.
            wt-clean() {
              local GIT=/usr/bin/git
              local display=()

              for wt_path in "$HOME"/Code/*/.claude/worktrees/*/; do
                [[ -d "$wt_path" ]] || continue
                local wt_path="''${wt_path%/}"
                local branch age dirty=""
                branch=$("$GIT" -C "$wt_path" branch --show-current 2>/dev/null || echo "(unknown)")
                age=$("$GIT" -C "$wt_path" log -1 --format="%ar" 2>/dev/null || echo "no commits")
                "$GIT" -C "$wt_path" diff --quiet 2>/dev/null || dirty=" [dirty]"
                display+=("$wt_path  branch=$branch  last=$age$dirty")
              done

              if [[ ''${#display[@]} -eq 0 ]]; then
                echo "wt-clean: no worktrees found under ~/Code" >&2
                return 0
              fi

              local selected
              selected=$(printf '%s\n' "''${display[@]}" | fzf -m --prompt="select worktrees to remove> " --header="TAB to multi-select, ENTER to confirm" < /dev/tty) || return 0
              [[ -z "$selected" ]] && return 0

              local LOG="$HOME/.claude/worktree.log"
              local _wt_log_fn
              _wt_log_fn() { echo "[$(/bin/date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

              while IFS= read -r line; do
                local path="''${line%%  *}"
                [[ -d "$path" ]] || continue

                # git-common-dir inside a worktree is <repo>/.git/worktrees/<name>
                # two levels up from that is the main repo root
                local git_common
                git_common=$("$GIT" -C "$path" rev-parse --git-common-dir 2>/dev/null) || continue
                # git_common is an absolute path like /repo/.git — parent is the repo root
                local repo="''${git_common%/.git}"
                # handle bare repos or unusual layouts: if it still ends in worktrees/* strip further
                [[ "$repo" == *"/worktrees/"* ]] && repo="''${repo%/worktrees/*}"
                repo="''${repo%/.git}"

                local branch default ahead
                branch=$("$GIT" -C "$path" branch --show-current 2>/dev/null || echo "")
                default=$("$GIT" -C "$repo" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo "origin/main")
                ahead=0
                [[ -n "$branch" ]] && ahead=$("$GIT" -C "$repo" rev-list --count "''${default}..''${branch}" 2>/dev/null || echo 0)

                "$GIT" -C "$repo" worktree remove --force "$path" 2>/dev/null || {
                  echo "wt-clean: failed to remove $path" >&2
                  continue
                }

                if [[ -n "$branch" ]]; then
                  if [[ "$ahead" == "0" ]]; then
                    "$GIT" -C "$repo" branch -D "$branch" 2>/dev/null || true
                    _wt_log_fn "CLEANED path=$path branch=$branch (0 commits ahead of $default)"
                    echo "wt-clean: removed $path and branch '$branch'"
                  else
                    _wt_log_fn "CLEANED path=$path branch=$branch preserved — $ahead commit(s) ahead of $default"
                    echo "wt-clean: removed $path; preserved branch '$branch' ($ahead commit(s) ahead of $default)"
                  fi
                else
                  _wt_log_fn "CLEANED path=$path (branch unknown)"
                  echo "wt-clean: removed $path"
                fi
              done <<< "$selected"
            }

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
