# Project Brief: Nix Configuration for MacOS + NixOS

## Overview
This is a comprehensive Nix configuration repository that provides declarative system management for multiple platforms and environments. It's a modified version of dustinlyons/nixos-config, adapted for personal and work use cases.

## Core Requirements
- **Multi-platform support**: Personal M1 MacBook Pro, work M1 MacBook Pro, NixOS desktop, NixOS server
- **Declarative configuration**: 100% flake-driven approach with no traditional configuration.nix
- **Reproducible environments**: Same environment across Linux and Mac using Nix and Home Manager
- **Secrets management**: Declarative secrets with agenix for SSH, PGP, and other sensitive data
- **Development tooling**: Comprehensive development environment with LSPs, formatters, linters, and DAPs

## Key Technologies
- **Nix Flakes**: Primary configuration mechanism
- **Home Manager**: User-level package and configuration management
- **nix-darwin**: MacOS system configuration
- **agenix**: Secrets management using SSH key pairs
- **disko**: Declarative disk management for NixOS

## Target Environments
1. **Personal MacOS** (M1 MacBook Pro) - Full desktop environment with GUI applications
2. **Work MacOS** (M1 MacBook Pro) - Work-specific configurations and tools
3. **NixOS Desktop** - Full GUI environment with window manager (bspwm)
4. **NixOS Server** (Hetzner VPS) - Headless server environment

## Goals
- Maintain consistent development environment across all platforms
- Enable quick system recovery and replication
- Manage secrets securely across environments
- Provide comprehensive development tooling (NeoVim, terminal tools, etc.)
- Support both personal and work workflows
