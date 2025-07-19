# Product Context: Personal Nix Configuration System

## Why This Project Exists
This configuration system solves the fundamental problem of maintaining consistent, reproducible development environments across multiple machines and platforms. It eliminates the "works on my machine" problem by ensuring identical tooling, configurations, and environments everywhere.

## Problems It Solves
1. **Environment Drift**: Prevents configuration inconsistencies between different machines
2. **Setup Time**: Reduces new machine setup from hours/days to minutes
3. **Backup/Recovery**: System configurations are version-controlled and recoverable
4. **Secret Management**: Securely manages SSH keys, API tokens, and other sensitive data
5. **Tool Consistency**: Ensures same versions of development tools across all environments

## How It Should Work
- **Single Command Setup**: New machines should be configurable with minimal commands
- **Automatic Updates**: Flake lock files ensure reproducible builds while allowing controlled updates
- **Cross-Platform**: Same user experience and tools on MacOS and NixOS
- **Secure by Default**: Secrets are encrypted and only accessible on authorized machines
- **Development Ready**: Complete development environment with editors, LSPs, formatters, debuggers

## User Experience Goals
- **Seamless Workflow**: Developers should have identical environments regardless of platform
- **Quick Recovery**: System failures should be recoverable within minutes
- **Easy Customization**: Host-specific configurations should be simple to manage
- **Secure Operations**: Sensitive data should be protected but easily accessible when needed
- **Minimal Maintenance**: System should self-update and require minimal manual intervention

## Key Features
- **Declarative MacOS**: Full MacOS configuration including UI, dock, and App Store apps
- **NeoVim Configuration**: Comprehensive editor setup with LSPs, plugins, and themes
- **Terminal Environment**: Consistent shell, prompt, and CLI tools across platforms
- **Development Tools**: Language servers, formatters, linters, and debuggers for multiple languages
- **Secrets Integration**: SSH keys, API tokens, and certificates managed declaratively
- **Theme Consistency**: Unified color schemes across all applications and terminals
