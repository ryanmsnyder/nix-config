## Shared
Much of the code running on MacOS or NixOS is actually found here.

This configuration gets imported by both modules. Some configuration examples include `git`, `zsh`, `vim`, and `tmux`.

## Layout
```
.
├── config/            # Config files not written in Nix (NeoVim, lf, etc)
├── cachix/            # Defines cachix, a global cache for builds
├── programs/          # Programs that can be installed using home-manager
├── default.nix        # Defines how we import overlays 
├── files.nix          # Non-Nix, static configuration files (now immutable!)
├── home-manager.nix   # Imports the individual program files from the programs directory
├── packages.nix       # List of packages to share

```
