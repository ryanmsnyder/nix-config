# Nix Config for MacOS + NixOS

This is a modified version of [this repo](https://github.com/dustinlyons/nixos-config).

## Overview

Nix is a powerful package manager for Linux and Unix systems that ensures reproducible, declarative, and reliable software management.

This repository contains my configuration for:

-   personal M1 MacBook Pro
-   work M1 MacBook Pro (haven't tested yet)
-   NixOS desktop (haven't tested yet because I don't have an environment to test with yet)
-   NixOS server (tested on a Hetzner base VM)

## Table of Contents

-   [Overview](#overview)
-   [Layout](#layout)
-   [Features](#features)
-   [Disclaimer](#disclaimer)
-   [Videos](#videos)
    -   [MacOS](#macos)
        -   [Updating dependencies with one command](#updating-dependencies-with-one-command)
    -   [NixOS](#nixos)
-   [Installing](#installing)
    -   [MacOS (Jan 2024)](#macos-jan-2024)
        -   [Install dependencies](#1-install-dependencies)
        -   [Install Nix](#2-install-nix)
        -   [Initialize a starter template](#3-initialize-a-starter-template)
        -   [Apply your current user info](#4-apply-your-current-user-info)
        -   [Decide what packages to install](#5-decide-what-packages-to-install)
        -   [Review your shell configuration](#7-review-your-shell-configuration)
        -   [Optional: Setup secrets](#8-optional-setup-secrets)
        -   [Install configuration](#9-install-configuration)
        -   [Make changes](#10-make-changes)
    -   [NixOS desktop](#nixos-desktop)
        -   [Burn the latest ISO](#1-burn-the-latest-iso)
        -   [Optional: Setup secrets](#2-optional-setup-secrets)
        -   [Install configuration](#3-install-configuration)
        -   [Set user password](#4-set-user-password)
    -   [NixOS server](#nixos-server)
        -   [Install `nix` on source machine](#1-install-nix-on-source-machine)
        -   [Setup server and enable SSH access](#2-setup-server-and-enable-ssh-access)
        -   [Optional: Setup secrets](#3-optional-setup-secrets)
        -   [Deploy configuration using `nixos-anywhere`](#4-deploy-configuration-using-nixos-anywhere)
        -   [SSH into target machine](#5-ssh-into-target-machine)
-   [How to Create Secrets](#how-to-create-secrets)
-   [Live ISO](#live-iso)
-   [Deploying Changes to Your System](#deploying-changes-to-your-system)
    -   [For all platforms](#for-all-platforms)
    -   [Update Dependencies](#update-dependencies)
-   [Compatibility and Testing](#compatibility-and-testing)
-   [Contributing](#contributing)
-   [Feedback and Questions](#feedback-and-questions)
-   [License](#license)
-   [Appendix](#appendix)
    -   [Why Nix Flakes](#why-nix-flakes)
    -   [NixOS Components](#nixos-components)
    -   [Stars](#stars)
    -   [Support](#support)

## Layout

```
.
├── apps         # Nix commands used to bootstrap and build configuration
├── hosts        # Host-specific configuration
├── modules      # MacOS and nix-darwin, NixOS, and shared configuration
├── overlays     # Drop an overlay file in this dir, and it runs. So far, mainly patches.
```

## Features

-   **Nix Flakes**: 100% flake driven, no `configuration.nix`, [no Nix channels](#why-nix-flakes)─ just `flake.nix`
-   **Same Environment Everywhere**: Easily share config across Linux and Mac (both Nix and Home Manager)
-   **MacOS Dream Setup**: Fully declarative MacOS, including UI, dock and MacOS App Store apps
-   **Simple Bootstrap**: Simple Nix commands to start from zero, both x86 and MacOS platforms
-   **Disk Management**: Declarative disk management with `disko`, say goodbye to disk utils
-   **Secrets Management**: Declarative secrets with `agenix` for SSH, PGP, syncthing, and other tools
-   **Built In Home Manager**: `home-manager` module for seamless configuration (no extra clunky CLI steps)
-   **NixOS Environment**: Extensively configured NixOS including clean aesthetic + window animations
-   **Nix Overlays**: [Auto-loading of Nix overlays](https://github.com/dustinlyons/nixos-config/tree/main/overlays): drop a file in a dir and it runs (great for patches!)
-   **Declarative Sync**: No-fuss Syncthing: managed keys, certs, and configuration across all platforms
-   **NeoVim Configuration**: Installs LSPs, linters, formatters, DAPs but let's lazy.nvim handle the installation of plugins as well as lazy loading plugins
-   **Simplicity and Readability**: Optimized for simplicity and readability in all cases, not small files everywhere
-   **Backed by Continuous Integration**: Flake automatically updates weekly if changes don't break starter build

## Disclaimers

1. Installing Nix on MacOS will create an entirely separate volume. It will exceed many gigabytes in size.

Some folks don't like this. If this is you, turn back now!

> [!NOTE]
> Don't worry; you can always [uninstall](https://github.com/DeterminateSystems/nix-installer#uninstalling) Nix later.

2. This config installs all packages via Home Manager, meaning the packages will only be available to the user of this config (they won't be available system-wide). The reason for this decision is two-fold:
    1. My current machines that are using this config don't have a need for system-wide installation.
    2. Making a distinction between packages that are installed system-wide vs packages that are only installed in my user's directory (via Home Manager) would complicate this config a little more.

## Videos

### MacOS

#### Updating dependencies with one command

https://github.com/dustinlyons/nixos-config/assets/1292576/2168d482-6eea-4b51-adc1-2ef1291b6598

### NixOS

https://github.com/dustinlyons/nixos-config/assets/1292576/fa54a87f-5971-41ee-98ce-09be048018b8

# Installing

> [!IMPORTANT]
> Note: Nix 2.18 currently [has a bug](https://github.com/NixOS/nix/issues/9052) that impacts this repository.

For now, if you run into errors like this:

```
error: path '/nix/store/52k8rqihijagzc2lkv17f4lw9kmh4ki6-gnugrep-3.11-info' is not valid
```

Run `nix copy` to make the path valid.

```
nix copy --from https://cache.nixos.org /nix/store/52k8rqihijagzc2lkv17f4lw9kmh4ki6-gnugrep-3.11-info
```

## MacOS (Jan 2024)

I've tested these instructions on a fresh Macbook Pro as of January 2024.

### 1. Install dependencies

```sh
xcode-select --install
```

### 2. Install Nix

Thank you for the installer, [Determinate Systems](https://determinate.systems/)!

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 3. Clone this repo into home directory

_Choose one of two options_

**Simplified version without secrets management**

-   Great for beginners, enables you to get started quickly and test out Nix.

-   Forgoring secrets means you must configure apps that depend on keys, passwords, etc., yourself.

-   You can always add secrets later.

**Full version with secrets management**

-   Choose this to add more moving parts for a 100% declarative configuration.

-   This template offers you a place to keep passwords, private keys, etc. _as part of your configuration_.

### 4. Make apps executable

```sh
find apps/aarch64-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name create-keys -o -name copy-keys -o -name check-keys \) -exec chmod +x {} \;
```

> [!NOTE]
> If you're using a git repository, only files in the working tree will be copied to the [Nix Store](https://zero-to-nix.com/concepts/nix-store).
>
> You must run `git add .` first.

### 8. Optional: Setup secrets

If you are using the starter with secrets, there are a few additional steps.

#### 8a. Create a private Github repo to hold your secrets

In Github, create a private [`nix-secrets`](https://github.com/dustinlyons/nix-secrets-example) repository. You'll enter this name during installation.

#### 8b. Install keys

Before generating your first build, these keys must exist in your `~/.ssh` directory. Don't worry, I provide a few commands to help you.

| Key Name | Platform | Description |

|---------------------|------------------|---------------------------------------|

| id_ed25519 | MacOS / NixOS | Used to download secrets from Github. |

| id_ed25519_agenix | MacOS / NixOS | Used to encrypt and decrypt secrets. |

You must run one of these commands:

##### Copy keys from USB drive

This command auto-detects a USB drive connected to the current system.

> Keys must be named `id_ed25519` and `id_ed25519_agenix`.

```sh
nix run .#copy-keys
```

##### Create new keys

```sh
nix run .#create-keys
```

> [!NOTE]
> If you choose this option, make sure to [save the value](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) of `id_ed25519.pub` to Github.

```sh
cat /Users/$USER/.ssh/id_ed25519.pub | pbcopy # Add to clipboard
```

##### Check existing keys

If you're rolling your own, just check they are installed correctly.

```sh
nix run .#check-keys
```

### 9. Install configuration

First-time installations require you to move the current `/etc/nix/nix.conf` out of the way.

```sh
[ -f /etc/nix/nix.conf ] && sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
```

> [!NOTE]
> If you're using a git repository, only files in the working tree will be copied to the [Nix Store](https://zero-to-nix.com/concepts/nix-store).
>
> You must run `git add .` first.

Then, if you want to ensure the build works before deploying the configuration, run:

```sh
nix run .#build
```

### 10. Make changes

Finally, alter your system with this command:

```sh
nix run .#build-switch
```

### 11. Enable/Allow Karabiner-Elements items

A couple of system messages relating to Karabiner-Elements will appear:

1. Click allow in Settings > Privacy & Security for the Karabiner-related item that appears in the Security section.

2. Enable karabiner_grabber and karabiner_observer in Settings > Privacy & Security > Input Monitoring.

### 12. Restart Mac

Restart your Mac so the Karabiner-Elements config will take effect.

> [!WARNING]
> On MacOS, your `.zshrc` file will be replaced with the [`zsh` configuration](https://github.com/dustinlyons/nixos-config/blob/main/templates/starter/modules/shared/home-manager.nix#L8) from this repository. So make some changes here first if you'd like.

## NixOS desktop

This configuration supports both `x86_64` and `aarch64` platforms for a Nix desktop (GUI) environment.

### 1. Burn the latest ISO

Download and burn [the minimal ISO image](https://nixos.org/download.html) to a USB, or create a new VM with the ISO as base.

> If you're building a VM on an Apple Silicon Mac, choose [64-bit ARM](https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-aarch64-linux.iso).

**Quick Links**

-   [64-bit Intel/AMD](https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-x86_64-linux.iso)

-   [64-bit ARM](https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-aarch64-linux.iso)

Boot the installer.

### 2. Optional: Setup secrets

If you are using the starter with secrets, there are a few additional steps.

#### 2a. Create a private Github repo to hold your secrets

In Github, create a private [`nix-secrets`](https://github.com/dustinlyons/nix-secrets-example) repository. You'll enter this name during installation.

#### 2b. Install keys

Before generating your first build, these keys must exist in your `~/.ssh` directory. Don't worry, I provide a few commands to help you.

| Key Name | Platform | Description |

|---------------------|------------------|---------------------------------------|

| id_ed25519 | MacOS / NixOS | Used to download secrets from Github. |

| id_ed25519_agenix | MacOS / NixOS | Used to encrypt and decrypt secrets. |

You must one run of these commands:

##### Copy keys from USB drive

This command auto-detects a USB drive connected to the current system.

> Keys must be named `id_ed25519` and `id_ed25519_agenix`.

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#copy-keys
```

##### Create new keys

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#create-keys
```

##### Check existing keys

If you're rolling your own, just check they are installed correctly.

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#check-keys
```

### 3. Install configuration

#### Run command

After the keys are in place, you're good to go. Run either of these commands:

> [!IMPORTANT]
> For Nvidia cards, select the second option, `nomodeset`, when booting the installer, or you will see a blank screen.

> [!CAUTION]
> Running this will reformat your drive to the `ext4` filesystem.

**Simple**

-   Great for beginners, enables you to get started quickly and test out Nix.

-   Forgoring secrets means you must configure apps that depend on keys, passwords, etc., yourself.

-   You can always add secrets later.

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#install
```

**With secrets**

-   Choose this to add more moving parts for a 100% declarative configuration.

-   This template offers you a place to keep passwords, private keys, etc. _as part of your configuration_.

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#install-with-secrets
```

### 4. Set user password

On first boot at the login screen:

-   Use the shortcut `Ctrl-Alt-F2` (or `Fn-Ctrl-Option-F2` if on a Mac) to move to a terminal session
-   Login as `root` using the password created during installation
-   Set the user password with `passwd <user>`
-   Go back to the login screen: `Ctrl-Alt-F7`

## NixOS server

This configuration supports both `x86_64` and `aarch64` platforms for a Nix server (no GUI) environment. This has been tested on the following platforms and setups:

-   Hetzner Cloud VM
    -   image: Ubuntu 22.04
    -   specs: 2 VCPU, 2 GB RAM, 40 GB Storage

These instructions will use [`nixos-anywhere`](https://github.com/nix-community/nixos-anywhere) to deploy the configuration to a server on a LAN or in the cloud.

### 1. Install `nix` on source machine

We'll be deploying the config from a source machine (most likely your computer) to a target machine (the server). Ensure `nix` is installed on your source machine.

```zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Setup server and enable SSH Access

If it's a cloud server, configure it to your liking but ensure that it has at least 2 GB RAM as recommended by `nixos-anywhere`. Ensure you have ssh access.

### 3. Optional: Setup secrets

If you are using the starter with secrets, there are a few additional steps.

#### 3a. Create a private Github repo to hold your secrets

In Github, create a private [`nix-secrets`](https://github.com/dustinlyons/nix-secrets-example) repository. You'll enter this name during installation.

#### 3b. Install keys

Before generating your first build, these keys must exist in your `~/.ssh` directory. Don't worry, I provide a few commands to help you.

| Key Name | Platform | Description |

|---------------------|------------------|---------------------------------------|

| id_ed25519 | MacOS / NixOS | Used to download secrets from Github. |

| id_ed25519_agenix | MacOS / NixOS | Used to encrypt and decrypt secrets. |

You must one run of these commands:

##### Copy keys from USB drive

This command auto-detects a USB drive connected to the current system.

> Keys must be named `id_ed25519` and `id_ed25519_agenix`.

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#copy-keys
```

##### Create new keys

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#create-keys
```

##### Check existing keys

If you're rolling your own, just check they are installed correctly.

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#check-keys
```

### 4. Deploy configuration using `nixos-anywhere`

> [!CAUTION]
> Running this will reformat your drive to the `ext4` filesystem.

**Deploying where source machine and target machine have same architecture**

i.e. You're deploying from a x86 Linux desktop to a x86 cloud server.

```zsh
nix run github:nix-community/nixos-anywhere -- --flake .#hetzner-vps root@<ip_address>
```

**Deploying where source machine has different architecture than target machine**

i.e. You're deploying from a M1 MacBook Pro to a x86 cloud server.

```zsh
nix run github:nix-community/nixos-anywhere -- --flake .#hetzner-vps root@<ip_address> --build-on-remote
```

### 5. SSH into target machine

```
ssh <user_in_config>@<server_ip_address>
```

You may see the following message the next time you try to log in to the target.

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
Please contact your system administrator.
Add correct host key in ~/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in ~/.ssh/known_hosts:6
  remove with:
  ssh-keygen -f ~/.ssh/known_hosts" -R "<ip addrress>"
Host key for <ip_address> has changed and you have requested strict checking.
Host key verification failed.
```

This is because the `known_hosts` file in the .ssh directory now contains a mismatch, since the server has been overwritten. To solve this, use a text editor to remove the old entry from the known_hosts file. The next connection attempt will then treat this as a new server.

# How to create secrets

To create a new secret `secret.age`, first [create a `secrets.nix` file](https://github.com/ryantm/agenix#tutorial) at the root of your `nix-secrets` repository.

> [!NOTE] > `secrets.nix` is interpreted by the imperative `agenix` commands to pick the "right" keys for your secrets.
>
> This file is not read when building your configuration.

**secrets.nix**

```nix
let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
  users = [ user1 ];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  systems = [ system1 ];
in
{
  "secret.age".publicKeys = [ user1 system1 ];
}
```

Now that we've configured `agenix` with our `secrets.nix`, it's time to create our first secret. Run the command below. Note, it assumes your SSH private key is in `~/.ssh/` or you can provide the `-i` flag with a path to your `id_ed25519` key.

```
EDITOR=vim nix run github:ryantm/agenix -- -e secret.age
```

This opens an editor to accept, encrypt, and write your secret to disk.

Commit the file to your `nix-secrets` repo and add a reference in the `secrets.nix` of your `nix-secrets` repository. References look like

```
{
  "secret.age".publicKeys = [ user1 system1 ];
}
```

where `"secret.age"` is your new filename. Now we have two files: `secrets.nix` and our `secret.age`. Let me show you.

## Example

Let's say I wanted to create a new secret to hold my Github SSH key.

I would `cd` into my `nix-secrets` repo directory, verify the `agenix` configuration (named `secrets.nix`) exists, then run

```
EDITOR=vim nix run github:ryantm/agenix -- -e github-ssh-key.age
```

This would start a `vim` session.

I would enter insert mode `:i`, copy+paste the key, hit Esc and then type `:w` to save it, resulting in the creation of a new file, `github-ssh-key.age`.

Then, I would edit `secrets.nix` to include a line specifying the public key to use for my new secret. I specify a user key, but I could just as easily specify a host key.

**secrets.nix**

```nix
let
  dustin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
  users = [ dustin ];
  systems = [ ];
in
{
  "github-ssh-key.age".publicKeys = [ dustin ];
}
```

Finally, I'd commit all changes to the `nix-secrets` repository, go back to my `nix-config` and run `nix flake update` to update the lock file.

The secret is now ready to use. Here's an [example](https://github.com/dustinlyons/nixos-config/blob/3b95252bc6facd7f61c6c68ceb1935481cb6b457/nixos/secrets.nix#L28) from my configuration. In the end, this creates a symlink to a decrypted file in the Nix Store that reflects my original file.

# Live ISO

Not yet available. Coming soon.

```sh
nix run --extra-experimental-features 'nix-command flakes' github:dustinlyons/nixos-config#live
```

# Deploying changes to your system

With Nix, changes to your system are made by

-   editing your system configuration
-   building the [system closure](https://zero-to-nix.com/concepts/closures)
-   creating and switching to it _(i.e creating a [new generation](https://nixos.wiki/wiki/Terms_and_Definitions_in_Nix_Project#generation))_

## For all platforms

```sh
nix run .#build-switch
```

## Update dependencies

```sh
nix flake update
```

## Compatibility and Testing

This configuration has been tested and confirmed working on the following platforms:

-   M1/M2/M3 Apple Silicon
-   Bare metal x86_64 PC
-   NixOS inside VMWare on MacOS
-   MacOS Sonoma inside Parallels on MacOS

## Contributing

Interested in contributing to this project? Here's how you can help:

-   **Code Contributions**: If you're interested in contributing code, please start by looking at open issues or feature requests. Fork the repository, make your changes, and submit a pull request. Make sure your code adheres to the existing style. For significant changes, consider opening an issue for discussion before starting work.

-   **Reporting Bugs**: If you encounter bugs or issues, please help by reporting them. Open a GitHub Issue and include as much detail as possible: what you were doing when the bug occurred, steps to reproduce the issue, and any relevant logs or error messages. This information will be invaluable in diagnosing and fixing the problem.

## Feedback and Questions

Have feedback or questions? Feel free to use the [discussion forum](https://github.com/dustinlyons/nixos-config/discussions).

## License

This project is released under the [MIT License](link-to-license).

## Appendix

### Why Nix Flakes

**Reasons to jump into flakes and skip `nix-env`, Nix channels, etc**

-   Flakes work just like other package managers you already know: `npm`, `cargo`, `poetry`, `composer`, etc. Channels work more like traditional Linux distributions (like Ubuntu), which most devs don't know.
-   Flakes encapsulate not just project dependencies, but Nix expressions, Nix apps, and other configurations in a single file. It's all there in a single file. This is nice.
-   Channels lock all packages to one big global `nixpkgs` version. Flakes lock each individual package to a version, which is more precise and makes it much easier to manage overall.
-   Flakes have a growing ecosystem (see [Flake Hub](https://flakehub.com/) or [Dev Env](https://devenv.sh/)), so you're future-proofing yourself.

### NixOS Components

| Component | Description |

| --------------------------- | :--------------------------------------------- |

| **Window Manager** | Xorg + bspwm |

| **Terminal Emulator** | alacritty |

| **Bar** | polybar |

| **Application Launcher** | rofi |

| **Notification Daemon** | dunst |

| **Display Manager** | lightdm |

| **File Manager** | thunar |

| **Text Editor** | emacs daemon mode |

| **Media Player** | cider |

| **Image Viewer** | feh |

| **Screenshot Software** | flameshot |
