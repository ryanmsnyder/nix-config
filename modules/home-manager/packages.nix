{ pkgs, inputs }:

with pkgs; [
  # AI
  ollama
  yek # Rust based tool to serialize text-based files in a repository or directory for LLM consumption
  # claude-code now managed via programs.claude-code in programs/claude.nix
  inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ccusage # Claude Code usage tracking
  inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
  inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli

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
  ast-grep # structural code search and replace using ASTs
  bun

  # Database
  postgresql

  # Cloud
  (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
  kubectl
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
  vscode
  obsidian
  # spotify  # Disabled: hash mismatch - nixpkgs needs update
  bruno
  google-chrome
  brave

  # macOS-specific Applications
  raycast
  bartender
  betterdisplay
  iina
  forklift
  homerow
  aerospace
  macwhisper
  duti
]
