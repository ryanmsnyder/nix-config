{ pkgs }:


{
  # Packages shared between NixOS server and desktop, and MacOS
  shared-non-gui-pkgs = with pkgs; [
    # AI
    ollama
    yek # Rust based tool to serialize text-based files in a repository or directory for LLM consumption

    # Development Tools
    nodejs_24
    uv
    gh
    coreutils
    sqlite
    iftop
    wget
    zip
    difftastic # syntax-aware diffing
    bun

    # Database
    postgresql

    # Cloud
    google-cloud-sdk
    terraform

    # Virtualization    
    docker
    docker-compose
    colima # alternative to docker desktop

    # Text and Terminal Utilities
    yt-dlp
    ffmpeg
    font-awesome
    tree
    unrar
    unzip

    # Fonts
    berkeley-mono-font # from overlays. installs to $HOME/Library/Fonts/HomeManager on MacOS

    # Firmware
    qmk

  ];

  # Shared GUI packages used by NixOS desktop and MacOS environments
  shared-gui-pkgs = with pkgs; [
    # bitwarden-desktop  # doesn't package the safari extension with it
    wezterm
    slack
    vscode
    obsidian
    spotify
    bruno
    google-chrome
    brave
  ];

  # Packages shared between NixOS desktop and NixOS server environments
  shared-nixos-pkgs = with pkgs; [
    home-manager
  ];

  # Packages shared between MacOS machines
  shared-macos-pkgs = with pkgs; [
    raycast
    bartender
    iina
    forklift
    homerow
    aerospace
    macwhisper
    claude-code
  ];

}
