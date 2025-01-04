{ pkgs }:


{
  # Packages shared between NixOS server and desktop, and MacOS
  shared-non-gui-pkgs = with pkgs; [
    # Development Tools
    kitty # command line tool for lf image viewing
    btop
    coreutils
    pandoc
    sqlite
    wget
    zip
    direnv
    difftastic # syntax-aware diffing

    # Terminal Enhancements and Utilities
    zoxide    # better cd
    lsd       # better ls
    starship  # zsh prompt
    fzf       # fuzzy finder

    # Cloud-Related Tools and SDKs
    docker
    docker-compose
    flyctl

    # Text and Terminal Utilities
    ffmpeg
    fd
    font-awesome
    htop
    iftop
    jq
    ripgrep
    tree
    tmux
    unrar
    unzip

    # Fonts
    berkeley-mono-font # from overlays. installs to $HOME/Library/Fonts/HomeManager on MacOS

  ];

  # Shared GUI packages used by NixOS desktop and MacOS environments
  shared-gui-pkgs = with pkgs; [
    wezterm
    slack
    vscode
    obsidian
    spotify
    bruno
    # google-chrome  # not packaged for MacOs
  ];

  # Packages shared between NixOS desktop and NixOS server environments
  shared-nixos-pkgs = with pkgs; [
    home-manager
  ];

  # Packages shared between MacOS machines
  shared-macos-pkgs = with pkgs; [
    raycast
    bartender
    monitorcontrol
    iina
    forklift
    homerow
  ];

}
