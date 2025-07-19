# System Patterns: Nix Configuration Architecture

## System Architecture
The configuration follows a modular, hierarchical structure that separates concerns and enables code reuse across platforms:

```
nix-config/
├── flake.nix                 # Entry point, defines all configurations
├── hosts/                    # Host-specific configurations
│   ├── personal-mac/         # Personal MacBook Pro
│   ├── work-macbookpro/      # Work MacBook Pro
│   └── hetzner-vps/          # NixOS server
├── modules/                  # Reusable configuration modules
│   ├── shared/               # Cross-platform modules
│   ├── darwin/               # MacOS-specific modules
│   └── nixos/                # NixOS-specific modules
├── overlays/                 # Package customizations
└── templates/                # Development environment templates
```

## Key Technical Decisions

### Flake-Driven Architecture
- **100% Flakes**: No traditional configuration.nix or channels
- **Lock Files**: Reproducible builds with flake.lock
- **Input Management**: All dependencies declared in flake inputs

### Module Organization
- **Shared Modules**: Common configurations used across all platforms
- **Platform Modules**: OS-specific configurations (darwin vs nixos)
- **Host Modules**: Machine-specific overrides and customizations

### Home Manager Integration
- **Built-in**: Home Manager integrated directly into system configurations
- **User-level**: All user packages and configurations managed through Home Manager
- **Cross-platform**: Same Home Manager modules work on MacOS and NixOS

## Design Patterns

### Configuration Inheritance
```nix
# Host inherits from platform modules, which inherit from shared modules
Host Config → Platform Modules → Shared Modules
```

### Secrets Management Pattern
- **agenix Integration**: SSH key-based encryption for secrets
- **Per-host Keys**: Each machine has its own decryption keys
- **Declarative**: Secrets declared in configuration, mounted at runtime

### Package Management Strategy
- **Shared Packages**: Common tools defined in shared/packages.nix
- **Platform Packages**: OS-specific packages (GUI vs CLI)
- **Host Packages**: Machine-specific tools and applications

### Theme System
- **Catppuccin Integration**: Unified theming across all applications
- **Flavor Support**: Different color variants (mocha, macchiato, etc.)
- **Consistent Colors**: Same theme applied to terminal, editor, and GUI apps

## Component Relationships

### Core Dependencies
- **nixpkgs**: Base package repository
- **home-manager**: User environment management
- **nix-darwin**: MacOS system configuration
- **agenix**: Secrets management
- **disko**: Disk partitioning (NixOS only)

### Application Integration
- **NeoVim**: Comprehensive editor with LSPs, themes, plugins
- **WezTerm**: Terminal with smart-splits integration
- **Shell Environment**: Zsh with starship prompt and useful aliases
- **Development Tools**: Language servers, formatters, debuggers

### Cross-Platform Abstractions
- **Shared Programs**: Same program configurations work on all platforms
- **Platform Adapters**: OS-specific implementations of shared interfaces
- **Conditional Logic**: Platform detection for OS-specific features

## Critical Implementation Paths

### System Deployment
1. **Bootstrap**: Clone repository and run platform-specific apply script
2. **Build**: Nix builds system configuration from flake
3. **Switch**: System switches to new configuration
4. **Secrets**: agenix mounts encrypted secrets using SSH keys

### Development Workflow
1. **Edit Configuration**: Modify Nix files in repository
2. **Test Build**: Use build scripts to verify configuration
3. **Deploy**: Use build-switch to apply changes
4. **Rollback**: Nix generations allow easy rollback if needed

### Secret Management Flow
1. **Key Generation**: Create SSH keys for encryption/decryption
2. **Secret Creation**: Use agenix CLI to encrypt secrets
3. **Configuration**: Declare secrets in host configurations
4. **Runtime**: Secrets automatically decrypted and mounted

### Multi-Host Management
1. **Hostname Detection**: Scripts detect current machine
2. **Configuration Selection**: Appropriate flake configuration chosen
3. **Host-Specific Overrides**: Machine-specific settings applied
4. **Shared Base**: Common configuration inherited from shared modules
