{ pkgs }:

let
  # Import custom Darwin
  customDarwinPackagesPath = ../../../custom-packages/macos;
  brunoDarwin = pkgs.callPackage (customDarwinPackagesPath + "/bruno.nix") {};
  plexDarwin = pkgs.callPackage (customDarwinPackagesPath + "/plex.nix") {};
in

{
  # Packages shared between NixOS server and desktop, and MacOS
  shared-command-line-pkgs = with pkgs; [
    # Development Tools
    kitty # command line tool for lf image viewing
    btop
    coreutils
    pandoc
    sqlite
    wget
    zip
    direnv

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

  ];

  # Shared GUI packages used by NixOS desktop and MacOS environments
  shared-gui-pkgs = with pkgs; [
    wezterm
    slack
    vscode
    obsidian
    spotify
    # google-chrome  # not packaged for MacOs
  ];

  # Packages shared between NixOS desktop and NixOS server environments
  shared-nixos-pkgs = with pkgs; [
    home-manager
  ];

  # Packages shared between MacOS machines
  shared-macos-pkgs = with pkgs; [
    raycast
    dockutil
    brunoDarwin
    plexDarwin
    monitorcontrol
  ];

}