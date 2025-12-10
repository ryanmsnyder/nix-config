{ pkgs }:

with pkgs; [
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

  # GUI Applications
  wezterm
  slack
  vscode
  obsidian
  # spotify  # Disabled: hash mismatch - nixpkgs needs update
  bruno
  google-chrome
  brave

  # macOS-specific Applications
  raycast
  bartender
  iina
  forklift
  homerow
  aerospace
  macwhisper
  claude-code
  duti
]
