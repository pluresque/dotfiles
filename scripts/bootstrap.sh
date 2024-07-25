#!/bin/bash

# Bootstrap script for setting up a new machine with Nix and Neovim
# Author: Pluresque
#
# Variables:
#   - REPO_URL: The URL of the git repository to clone.
#   - SOURCE_DIR: The directory name where the repository will be cloned.
#
# Notes:
#   - The script assumes a UNIX-like environment (macOS or Linux).
#   - On macOS, Xcode Command Line Tools and Homebrew will be installed if not 
#     already present.
#
# Execution:
#   - Run this script in a terminal:
#     $ /bin/bash bootstrap.sh
#     
# Functions:
#   - confirm: Prompts the user for a yes/no confirmation.
#   - confirm_and_execute: Prints a command and asks for confirmation before 
#     executing it.
#
#   - is_installed: Checks if a specified command is installed.
#   - is_xcode_installed: Checks if Xcode Command Line Tools are installed.
#
#   - install_nix: Installs Nix package manager.
#   - install_homebrew: Installs Homebrew package manager (macOS only).
#   - install_xcode: Installs Xcode Command Line Tools (macOS only).
#   - install_git: Prompts user to manually install Git if not found.
#
#   - clone_repo: Clones the specified git repository.
#   - move_neovim_folder: Moves Neovim configuration folder to the appropriate 
#     location.
#   - install_dependencies: Installs necessary dependencies based on the 
#     operating system.
#
#   - main: Main function that orchestrates the setup process.


set -e

# Colorful output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Variables
REPO_URL='git@github.com:pluresque/dotfiles.git'
SOURCE_DIR='dotfiles'
NEOVIM_DIR="$HOME/.config/nvim"
NIX_DIR="$HOME/.config/nix"


echo_red() {
    echo -e "${RED}$1${NC}"
}

echo_success() {
    echo -e "${GREEN}$1${NC}"
}

confirm() {
    read -p "$1 (y/n): " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

# Prints a command and asks for confirmation before executing it
confirm_and_execute() {
    echo "This command will be executed:"
    echo_red "$2"
    confirm "$1" && {
        $2
    }
}

# Checks if specified command is installed
is_installed() {
    if command -v "$1" &> /dev/null; then
        echo_success "$1 is installed."
        return 0
    else
        return 1
    fi
}

is_xcode_installed() {
    if xcode-select -p &> /dev/null; then
        echo_success "xcode cli tools are installed."
        return 0
    else
        return 1
    fi
}

install_nix() {
    confirm_and_execute "Do you want to install Nix?" "curl -L https://nixos.org/nix/install | sh"
}

install_homebrew() {
    confirm_and_execute "Do you want to install Homebrew?" "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
}

install_xcode() {
    confirm_and_execute "Do you want to install Xcode Command Line Tools?" "xcode-select --install"
}

install_git() {
    echo "Please install Git on your machine. Normally, it should be installed, check if your PATH is set correctly."
}

clone_repo() {
    confirm_and_execute "Do you want to clone the repository into the current folder?" "git clone $REPO_URL $SOURCE_DIR"
}

move_neovim_folder() {
    if [ -d "$SOURCE_DIR/.config/nvim" ]; then
        if [ -d "$HOME/.config/nvim" ]; then
            echo_red "The directory ~/.config/nvim already exists."
        else
            echo_red "Moving neovim folder to ~/.config/nvim"
            mv "$SOURCE_DIR/.config/nvim" ~/.config/nvim
            echo_success "neovim folder moved successfully to ~/.config/nvim"
        fi
    else
        echo_red "The directory $SOURCE_DIR/.config/nvim does not exist"
    fi
}

install_dependencies() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
      is_xcode_installed || install_xcode
      is_installed brew || install_homebrew
  elif [[ "$OSTYPE" == "linux"* ]]; then
      echo "Linux detected"
  else
      echo "Unsupported OS type: $OSTYPE"
      exit 1
  fi
  is_installed nix || install_nix
  is_installed git || install_git
}

main() {
  echo_red "Following settings will be used:"
  echo "  Repository URL: $REPO_URL"
  echo "  Source directory: $SOURCE_DIR"
  echo "  Neovim directory: $NEOVIM_DIR"
  echo "  Nix directory: $NIX_DIR"
  echo ""
  
  echo_red "Please read the script before running it."
  confirm "Do you want to continue?" || {
      echo_red "Aborting."
      exit 1
  }
 
  echo ""
  echo "Checking dependencies:"
  install_dependencies
  echo ""

  clone_repo
  move_neovim_folder
}

main
