# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix Flakes-based configuration for managing macOS and NixOS systems. It uses nix-darwin for macOS system configuration, Home Manager for user environment configuration, and supports multi-platform deployments including personal Mac, work MacBook, and Linux servers.

## Build and Development Commands

### Core Build Commands
- `nix run .#build` - Build the system configuration without switching
- `nix run .#build-switch` - Build and switch to new system configuration (recommended for daily use)
- `nix flake update` - Update all flake inputs to latest versions

### Platform-Specific Commands
The system automatically detects hostname and maps to appropriate flake configuration via `hostname-to-flake-map.txt`:
- `personal-mac` - Personal M1 MacBook Pro configuration
- `work-macbookpro` - Work MacBook Pro configuration
- `hetzner-vps` - NixOS server configuration

### Key Management (for secrets using agenix)
- `nix run .#create-keys` - Create new SSH keys for agenix encryption
- `nix run .#copy-keys` - Copy keys from USB drive
- `nix run .#check-keys` - Verify key installation

### Initial Setup Commands
For first-time installation on macOS:
```bash
# Make apps executable
find apps/aarch64-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name create-keys -o -name copy-keys -o -name check-keys \) -exec chmod +x {} \;

# Initial build (before system nix.conf is configured)
nix run --extra-experimental-features nix-command --extra-experimental-features flakes .#build

# Build and switch
nix run --extra-experimental-features nix-command --extra-experimental-features flakes .#build-switch
```

## Architecture and Structure

### Directory Layout
```
├── apps/           # Platform-specific executable scripts for build/deployment
├── hosts/          # Host-specific configurations (personal-mac, work-macbookpro, hetzner-vps)
├── modules/        # Reusable configuration modules
│   ├── darwin/     # macOS-specific modules (system defaults, homebrew, dock)
│   ├── nixos/      # NixOS-specific modules
│   └── shared/     # Cross-platform modules (home-manager configs)
├── overlays/       # Nix package overlays for custom/patched packages
└── templates/      # Development environment templates
```

### Key Configuration Files
- `flake.nix` - Main flake configuration defining inputs, outputs, and system configurations
- `hostname-to-flake-map.txt` - Maps hostnames to flake configurations for automatic detection
- `modules/shared/home-manager/` - User environment configuration (dotfiles, programs, themes)
- `modules/shared/home-manager/config/neovim/` - Comprehensive Neovim configuration with LSPs, DAPs, and plugins

### Flake Architecture
The flake.nix defines multiple system configurations:
- `darwinConfigurations` - macOS systems using nix-darwin
- `nixosConfigurations` - Linux systems using NixOS
- Variables are defined for user information (personal vs work profiles)
- Home Manager is integrated for user-level package management

### Secrets Management
Uses `agenix` for declarative secrets management:
- Private keys stored in `~/.ssh/agenix-id_ed25519`
- Secrets encrypted and stored in separate private `nix-secrets` repository
- Secrets automatically decrypted and mounted during system build

### Key Features
- **Hostname-based Configuration**: System automatically detects hostname and applies appropriate configuration
- **Cross-Platform Home Manager**: Shared user configurations work across macOS and Linux
- **Declarative macOS**: Full system configuration including dock, system preferences, and App Store apps
- **Modular Architecture**: Configurations are split into reusable modules
- **Auto-loading Overlays**: Drop overlay files in `overlays/` directory and they're automatically loaded
- **Comprehensive Neovim Setup**: Pre-configured with LSPs, formatters, DAPs, and modern plugin ecosystem

### Package Management Strategy
- System packages installed via nix-darwin (macOS) or NixOS configuration
- User packages managed through Home Manager
- macOS App Store apps installed via `mas` through nix-homebrew
- Custom packages and patches applied through overlays

## Development Workflow

1. Make configuration changes in appropriate module files
2. Test with `nix run .#build` to ensure configuration builds successfully
3. Apply changes with `nix run .#build-switch`
4. Update dependencies periodically with `nix flake update`

For secrets management:
1. Edit secrets in separate `nix-secrets` repository using `agenix` CLI
2. Update flake lock to pull latest secrets: `nix flake lock --update-input secrets`
3. Rebuild system configuration to apply new secrets