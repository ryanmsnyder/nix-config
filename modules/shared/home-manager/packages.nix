{ pkgs }:


{
  # Packages shared between NixOS server and desktop, and MacOS
  shared-non-gui-pkgs = with pkgs; [
    # AI
    ollama

    # Development Tools
    coreutils
    sqlite
    iftop
    wget
    zip
    difftastic # syntax-aware diffing

    # Virtualization    
    docker
    docker-compose
    colima # alternative to docker desktop

    # Cloud-Related Tools and SDKs
    flyctl

    # Text and Terminal Utilities
    ffmpeg
    font-awesome
    tree
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
    aerospace
    macwhisper
  ];

}
