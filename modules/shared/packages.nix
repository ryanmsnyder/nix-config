{ pkgs }:

with pkgs; [
  # Development Tools
  wezterm
  kitty  # just for kitty command line tool for previewing images in lf
  vscode # FIXME: need to exclude from nixos server environments

  # System Management Utilities
  btop
  coreutils
  pandoc
  sqlite
  wget
  zip

  # Terminal Enhancements and Utilities
  zoxide    # better cd
  bat       # better cat
  lsd       # better ls
  starship  # zsh prompt
  fzf       # fuzzy finder
  # lf        # file manager

  # Cloud-Related Tools and SDKs
  docker
  docker-compose
  flyctl

  # Productivity Tools
  obsidian

  # Media-Related Packages
  ffmpeg
  fd
  font-awesome

  # Text and Terminal Utilities
  htop
  iftop
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip
]
