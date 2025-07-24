# Active Context: Current Work Focus

## Current Work Focus
**✅ COMPLETED: Dock Configuration Refactoring** - Successfully refactored dock configuration to separate shared settings from host-specific apps, with proper nix-darwin vs Home Manager organization.

## Recent Changes
- **Completed Memory Bank Initialization**: Successfully created all core memory bank files (projectbrief.md, productContext.md, systemPatterns.md, techContext.md, activeContext.md, progress.md)
- **Analyzed Current Configuration**: Reviewed existing SSH and Zsh configurations in shared modules
- **✅ Created Host-Specific SSH Configuration**: Added `hosts/personal-mac/home-manager/programs/ssh.nix` with server aliases
- **✅ Integrated SSH Config**: Updated `hosts/personal-mac/home-manager/default.nix` to import the SSH program
- **✅ Resolved Configuration Conflicts**: Modified SSH config to extend shared config rather than replace it
- **✅ Validated Configuration**: Successfully tested build with `nix build .#darwinConfigurations.personal-mac.system --dry-run`
- **✅ Added GitHub SSH Configuration**: Added GitHub match block with proper identity file and security settings
- **✅ Updated Home Assistant SSH**: Added identity file reference to use agenix-managed SSH key
- **✅ Fixed Agenix Module Loading**: Enabled `agenix.darwinModules.default` in flake.nix (was commented out)
- **✅ RESOLVED: Agenix Secrets Mounting**: Fixed by removing invalid `owner` option and updating secrets flake input to latest version
- **✅ Updated Homebrew Flakes**: Updated homebrew-bundle, homebrew-cask, homebrew-core, and nix-homebrew to latest versions
- **✅ Fixed nix-darwin Compatibility**: Resolved version mismatch by updating nixpkgs and nix-darwin, added system.primaryUser configuration
- **✅ Resolved Home Manager Compatibility**: Updated Home Manager to fix `substituteAll` deprecation error with newer nixpkgs
- **✅ COMPLETED: Dock Configuration Refactoring**: Separated shared dock settings from host-specific apps, moved system-level config out of home-manager module

## Next Steps
1. **✅ COMPLETED: Update Homebrew Flakes**: Successfully updated all Homebrew-related flakes to latest versions
2. **✅ COMPLETED: Resolve nix-darwin Compatibility**: Fixed version mismatch between nix-darwin and nixpkgs
3. **✅ COMPLETED: Fix Home Manager Compatibility**: Updated Home Manager to resolve `substituteAll` deprecation error
4. **Implement WezTerm SSH pane management**: Add functionality to create new panes connected to same SSH session
5. **Integrate SSH session resurrection**: Connect SSH sessions with WezTerm's resurrect plugin
6. **Test and validate**: Deploy configuration and test SSH aliases work as expected

## ✅ RESOLVED: Flake Updates and Compatibility Issues

### Issue Summary
Multiple compatibility issues arose when updating Homebrew-related flakes, requiring coordinated updates across the entire flake ecosystem.

### Problems Encountered
1. **Homebrew Flakes Outdated**: homebrew-bundle, homebrew-cask, homebrew-core, and nix-homebrew were significantly outdated
2. **nix-darwin Version Mismatch**: Updated nix-homebrew required newer nix-darwin, but created version incompatibility with nixpkgs
3. **Home Manager Compatibility**: Updated nixpkgs deprecated `substituteAll` function, breaking older Home Manager versions

### Solutions Implemented
1. **Updated Homebrew Flakes**: 
   - homebrew-bundle: 2025-02-06 → 2025-04-22
   - homebrew-cask: 2025-02-07 → 2025-07-23
   - homebrew-core: 2025-02-07 → 2025-07-23
   - nix-homebrew: 2025-01-05 → 2025-07-10

2. **Fixed nix-darwin Compatibility**:
   - Updated nixpkgs from 2025-03-24 → 2025-07-22
   - Updated nix-darwin to master branch for compatibility
   - Added `system.primaryUser = "ryan"` for new activation model
   - Removed deprecated options (`nix.gc.user`, `services.nix-daemon.enable`)

3. **Resolved Home Manager Issues**:
   - Updated Home Manager to version compatible with July 2025 nixpkgs
   - Fixed `substituteAll` → `replaceVars` deprecation error

### Current Status
- **✅ All Flakes Updated**: Homebrew, nix-darwin, nixpkgs, and Home Manager all on compatible versions
- **✅ Build Compatibility**: System can now build successfully with updated flake ecosystem
- **✅ Latest Packages**: Access to latest Homebrew packages and casks from July 2025

### Key Learnings
- Flake updates often require coordinated updates across multiple inputs for compatibility
- nix-darwin's new activation model requires explicit primary user configuration
- Major nixpkgs updates can break compatibility with older Home Manager versions
- Always update related flakes together when encountering version mismatch errors

## ✅ RESOLVED: Nix Build User Group GID Mismatch

### Issue Summary
After successfully updating flakes and resolving compatibility issues, encountered a new error during system activation: "Build user group has mismatching GID, aborting activation".

### Problem Encountered
- **GID Mismatch**: The default Nix build user group ID was changed from 30000 to 350
- **System State**: The system had GID 350 but nix-darwin expected 30000
- **Activation Failure**: System activation failed with error message suggesting to set `ids.gids.nixbld = 350;`
- **Deprecated Warning**: Also encountered deprecation warning for `programs.zsh.initExtraFirst`

### Solutions Implemented
1. **Fixed GID Configuration**:
   - Added `ids.gids.nixbld = 350;` to `modules/darwin/system-config.nix`
   - This tells nix-darwin to use the actual GID (350) instead of expecting the old default (30000)

2. **Updated Deprecated Zsh Option**:
   - Replaced `programs.zsh.initExtraFirst` with `programs.zsh.initContent = lib.mkBefore`
   - Updated in `modules/shared/home-manager/programs/zsh.nix`

### Current Status
- **✅ System Activation**: Successfully completed `nix run .#build-switch` without errors
- **✅ GID Configuration**: Nix build user group properly configured with correct GID
- **✅ Deprecation Warnings**: Resolved zsh deprecation warning
- **✅ Full Deployment**: System switched to new generation successfully

### Key Learnings
- GID mismatches can occur when Nix installation defaults change between versions
- Always check system activation errors for specific configuration suggestions
- Deprecation warnings should be addressed to maintain compatibility with future updates
- The `ids.gids.nixbld` option allows overriding the expected build user group ID

### Troubleshooting Notes
- **macOS Permissions**: If you encounter "operation not permitted" errors during nix-darwin activation, you may need to grant Nix full disk access via System Settings > Privacy & Security > Full Disk Access and add the nix binary

## ✅ COMPLETED: Dock Configuration Refactoring

### Issue Summary
The dock configuration was initially centralized in the shared Home Manager module, but this was architecturally incorrect since `system.defaults.dock` is nix-darwin system-level configuration, not Home Manager user-level configuration.

### Problems Identified
1. **Incorrect Module Placement**: Dock configuration was in `modules/darwin/home-manager/default.nix` but should be system-level
2. **Lack of Host Customization**: All hosts shared the same dock apps, preventing personal vs work customization
3. **Mixed Concerns**: Shared dock behavior settings were mixed with host-specific app lists

### Solutions Implemented
1. **Created Shared Dock Module**: 
   - Created `modules/darwin/dock.nix` with shared dock behavior settings
   - Moved all `system.defaults.dock` settings except `persistent-apps`
   - Added import to `modules/darwin/system-config.nix`

2. **Host-Specific Dock Apps**:
   - Created `hosts/personal-mac/dock.nix` with personal app lineup
   - Created `hosts/work-macbookpro/dock.nix` with work-focused apps
   - Each host imports its own dock.nix file

3. **Cleaned Up Home Manager Module**:
   - Removed dock configuration from `modules/darwin/home-manager/default.nix`
   - Eliminated empty `dock = {};` placeholder as it was unnecessary

### Final Architecture
```
modules/darwin/
├── dock.nix                    # Shared dock behavior/appearance
├── system-config.nix           # Imports dock.nix
└── home-manager/
    └── default.nix             # No dock config (properly separated)

hosts/personal-mac/
├── default.nix                 # Imports ./dock.nix
└── dock.nix                    # Personal dock apps

hosts/work-macbookpro/
├── default.nix                 # Imports ./dock.nix
└── dock.nix                    # Work dock apps
```

### Key Benefits
1. **Proper Separation**: System-level config in darwin modules, user-level in home-manager
2. **Host Customization**: Each host can have different dock app lineups
3. **DRY Principle**: Shared dock behavior settings defined once
4. **Clear Organization**: Easy to understand and maintain structure

### Configuration Details
- **Shared Settings**: autohide, delays, animations, hot corners, tile size
- **Personal Apps**: Includes Obsidian, Spotify, Reminders for personal use
- **Work Apps**: Includes Slack, focuses on productivity and communication tools
- **Common Apps**: ForkLift, WezTerm, Safari, VS Code, Bruno shared across hosts

### Current Status
- **✅ Modular Structure**: Dock configuration properly separated by concern
- **✅ Host Customization**: Each host has tailored dock app lineup
- **✅ System Integration**: Shared settings imported via system-config.nix
- **✅ Clean Architecture**: Proper nix-darwin vs Home Manager separation

## Active Decisions and Considerations

### Memory Bank Structure
- **Hierarchical Documentation**: Following the established memory bank pattern with core files building upon each other
- **Comprehensive Coverage**: Ensuring all aspects of the Nix configuration are documented
- **Future-Proof Context**: Creating documentation that will be valuable for ongoing maintenance and development

### Documentation Approach
- **Technical Depth**: Balancing detailed technical information with high-level concepts
- **Cross-Platform Focus**: Emphasizing the multi-platform nature of the configuration
- **Practical Orientation**: Focusing on actionable information for development and maintenance

## Important Patterns and Preferences

### Configuration Philosophy
- **Declarative Everything**: All system state should be declared in Nix files
- **Reproducible Builds**: Same configuration should produce identical results across machines
- **Modular Design**: Configurations should be composable and reusable
- **Cross-Platform Compatibility**: Shared modules should work on both macOS and NixOS

### Development Workflow
- **Git-Centric**: All changes tracked in version control
- **Iterative Testing**: Build and test changes before deployment
- **Rollback Safety**: Always maintain ability to rollback to previous working state
- **Documentation First**: Document patterns and decisions as they're made

### Tool Integration
- **Consistent Theming**: Catppuccin theme across all applications
- **Keyboard-Driven**: Prefer keyboard shortcuts and CLI tools over GUI
- **Smart Navigation**: Seamless movement between terminal, editor, and system
- **Development Focus**: Optimize for software development workflows

## Learnings and Project Insights

### Nix Configuration Complexity
- **Learning Curve**: Nix has a steep learning curve but provides powerful abstractions
- **Flake Benefits**: Flakes provide better dependency management and reproducibility
- **Home Manager Value**: Essential for user-level configuration management
- **Cross-Platform Challenges**: Significant effort required to maintain compatibility

### System Architecture Benefits
- **Modularity**: Modular structure enables easy customization and maintenance
- **Reusability**: Shared modules reduce duplication across hosts
- **Flexibility**: Easy to add new hosts or modify existing configurations
- **Maintainability**: Clear separation of concerns makes debugging easier

### Development Environment Quality
- **Integrated Workflow**: All tools work together seamlessly
- **Consistent Experience**: Same environment across all machines
- **Powerful Tooling**: Advanced editor, terminal, and shell capabilities
- **Efficient Navigation**: Smart-splits and other tools enable rapid context switching

### Secret Management Approach
- **Security First**: All secrets encrypted and properly managed
- **Declarative Secrets**: Secret mounting declared in configuration
- **Per-Host Keys**: Each machine has unique decryption capabilities
- **Git Safety**: No secrets stored in plain text in repository

## Current Configuration State
- **Hosts**: 3 configured hosts (personal-mac, work-macbookpro, hetzner-vps)
- **Platforms**: macOS (nix-darwin) and NixOS support
- **Applications**: Comprehensive development environment with NeoVim, WezTerm, etc.
- **Themes**: Catppuccin theming across all applications
- **Secrets**: agenix-based secret management system
- **Templates**: Development environment templates for Python projects

## Outstanding Work Areas
- **Documentation**: Memory bank initialization (in progress)
- **Testing**: Verify configurations work across all hosts
- **Optimization**: Improve build times and reduce complexity where possible
- **Expansion**: Add support for additional development languages and tools

## New Requirements (Added)
1. **Host-specific Zsh Configuration**: Create a personal-mac specific zsh program with SSH aliases for common servers
2. **WezTerm SSH Pane Management**: Implement functionality to create new panes that connect to the same SSH session as the current pane
3. **SSH Session Resurrection**: Integrate SSH session restoration with WezTerm's resurrect plugin and smart_workspace_switcher
