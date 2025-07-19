# Technical Context: Nix Configuration System

## Technologies Used

### Core Nix Ecosystem
- **Nix Package Manager**: Functional package manager with reproducible builds
- **Nix Flakes**: Modern Nix interface for dependency management and configuration
- **nixpkgs**: The Nix package repository with 80,000+ packages
- **Home Manager**: Declarative user environment management
- **nix-darwin**: Nix-based system configuration for macOS
- **NixOS**: Linux distribution built on Nix package manager

### Development Environment
- **NeoVim**: Highly configurable text editor with Lua configuration
- **WezTerm**: GPU-accelerated terminal emulator with Lua scripting
- **Zsh**: Advanced shell with completion and customization
- **Starship**: Cross-shell prompt with Git integration
- **Catppuccin**: Consistent color scheme across all applications

### Language Support & Tooling
- **Language Servers**: pyright, lua-language-server, typescript-language-server
- **Formatters**: black (Python), prettier (JS/TS), stylua (Lua), alejandra (Nix)
- **Linters**: ruff (Python), eslint (JS/TS), statix (Nix)
- **Debuggers**: debugpy (Python), nvim-dap integration

### Security & Secrets
- **agenix**: Age-based secrets management for Nix
- **SSH Keys**: Ed25519 keys for GitHub and secret encryption
- **GPG**: For additional encryption and signing needs

### Platform-Specific Tools
#### macOS
- **Homebrew**: Package manager for macOS-specific applications
- **Karabiner-Elements**: Keyboard customization and key remapping
- **Raycast**: Application launcher and productivity tool
- **Aerospace**: Tiling window manager for macOS

#### NixOS
- **systemd**: Service management and system initialization
- **disko**: Declarative disk partitioning and formatting
- **GRUB**: Boot loader configuration

## Development Setup

### Prerequisites
- **Git**: Version control system
- **SSH Keys**: For GitHub access and secret decryption
- **Nix**: Package manager (installed via Determinate Systems installer)

### Build Tools
- **Flake Commands**: `nix build`, `nix develop`, `nix run`
- **Platform Scripts**: Custom build and deployment scripts in `apps/`
- **Home Manager**: User environment rebuilding

### Development Workflow Tools
- **direnv**: Automatic environment loading for projects
- **zoxide**: Smart directory jumping
- **fzf**: Fuzzy finder for files and commands
- **ripgrep**: Fast text search tool
- **fd**: Fast file finder
- **bat**: Syntax-highlighted file viewer

## Technical Constraints

### Nix Limitations
- **Learning Curve**: Nix language and concepts require significant learning
- **Build Times**: Initial builds can be slow, especially for large configurations
- **Storage**: Nix store can consume significant disk space
- **Binary Caches**: Dependency on external binary caches for performance

### Platform Constraints
#### macOS
- **System Integrity Protection**: Limits system-level modifications
- **App Store Apps**: Some applications require manual installation
- **Homebrew Dependencies**: Some packages only available through Homebrew

#### NixOS
- **Hardware Support**: May require additional configuration for specific hardware
- **Proprietary Software**: Limited support for proprietary applications
- **Gaming**: Reduced compatibility compared to traditional Linux distributions

### Cross-Platform Challenges
- **Path Differences**: Different file system layouts between macOS and Linux
- **Package Availability**: Not all packages available on all platforms
- **Configuration Differences**: Some applications require platform-specific settings

## Tool Usage Patterns

### Configuration Management
- **Declarative**: All system state declared in Nix files
- **Version Controlled**: All configurations tracked in Git
- **Atomic Updates**: System changes applied atomically
- **Rollback Support**: Easy rollback to previous configurations

### Secret Management
- **Encrypted at Rest**: All secrets encrypted with age
- **SSH Key Access**: Decryption tied to SSH private keys
- **Declarative Mounting**: Secrets automatically mounted where needed
- **Per-Host Keys**: Each machine has unique decryption capabilities

### Development Environment
- **Language-Specific**: Separate development shells for different languages
- **Reproducible**: Same environment across all machines
- **Isolated**: Project dependencies don't conflict with system packages
- **Template-Based**: Reusable templates for common project types

### Package Management
- **Layered Approach**: System packages + user packages + project packages
- **Shared Definitions**: Common packages defined once, used everywhere
- **Platform Adaptation**: Conditional package inclusion based on platform
- **Overlay System**: Custom package modifications and additions

## Integration Points

### Editor Integration
- **LSP Support**: Language servers configured for all supported languages
- **Theme Consistency**: Same color scheme in editor and terminal
- **Plugin Management**: Lazy.nvim for plugin installation and loading
- **Debugging**: DAP integration for debugging support

### Terminal Integration
- **Smart Splits**: Seamless navigation between terminal and editor panes
- **Session Management**: WezTerm workspace and session persistence
- **Shell Enhancement**: Advanced completion, history, and navigation
- **Theme Synchronization**: Consistent colors across all terminal applications

### System Integration
- **Keyboard Shortcuts**: Consistent key bindings across applications
- **Window Management**: Tiling window manager integration
- **Application Launcher**: Quick access to applications and commands
- **Notification System**: Unified notification handling
