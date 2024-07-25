![image](images/overview.jpeg)

> **Disclaimer:** _This is not a community framework or distribution._ It's a
> private configuration and an ongoing experiment to feel out NixOS. Feel free
> to use it as a reference.

# Overview

This repository contains my personal everchanging configuration for a general-purpose development environment that runs Nix on macOS, NixOS, or any other Linux (yet to be done). Due to limitations both Windows and WSL are not supported and likely will never be.

## Features
- **Nix Flakes**: 100% flake driven, no `configuration.nix`, no Nix channels ─ just `flake.nix`
- **Managed Homebrew**: Zero maintenance homebrew environment 
- **Consistent Environment**: Easily share config across Linux and macOS (both Nix and Home Manager)
- **Nix Darwin**: Fully declarative macOS (Apple / Intel) w/ UI, dock and macOS App Store apps
- **Neovim**: IDE-like experience with LSP, Treesitter and more

## Components

| Component                   | Description                                     | 
| --------------------------- | :---------------------------------------------  |
| **Window Manager**          | Amethyst + skhd                                 |
| **Terminal Emulator**       | Wezterm                                         |
| **Text Editor**             | neovim                                          |
| **Application Launcher**    | Raycast                                         |
| **File Manager**            | yazi                                            |

## Repository Structure

- `flake.nix`: Entrypoint for hosts and home configurations.
- `home`: home-manager configuration
- `modules`: general modules, each can be toggled on or off in `flake.nix`

# Installation

**Requirements**: macOS or Linux machine, Git, Bash.

1. Clone this repo

```bash
git clone https://github.com/pluresque/dotfiles.git
```

2. Run bootstrap [script](scripts/bootstrap.sh). It's a good practise to check the script before running it!

```bash
/bin/bash -c ./scripts/bootstrap.sh
```

# Resources
1. [Nix Flakes Book](https://github.com/ryan4yin/nixos-and-flakes-book)
2. [Nix Options and Flakes](https://search.nixos.org) 
