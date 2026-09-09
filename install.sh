#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/MRo47/dotfiles/main"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/bash"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

if ! command -v starship >/dev/null 2>&1; then
  echo "Installing Starship..."
  curl -fsSL https://starship.rs/install.sh | \
    sh -s -- -y -b "$HOME/.local/bin"
fi

curl -fsSL \
  "$REPO_RAW/starship.toml" \
  -o "$HOME/.config/starship.toml"

curl -fsSL \
  "$REPO_RAW/bashrc.d/terminal-setup.sh" \
  -o "$HOME/.config/bash/terminal-setup.sh"