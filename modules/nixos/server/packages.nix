{ pkgs }:

with pkgs;
let shared-packages = import ../../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # Security and authentication
  yubikey-agent

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager

  # Media and design tools
  fontconfig

  # Productivity tools
  bc # old school calculator

  # Audio tools
  cava # Terminal audio visualizer

  # Testing and development tools
  direnv
  rnix-lsp # lsp-mode for nix
  postgresql

  # Text and terminal utilities
  tree
  unixtools.ifconfig
  unixtools.netstat

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  libnotify
  playerctl # Control media players from command line
  pinentry-curses
  sqlite
  xdg-utils

  # Other utilities
  xdotool
]
