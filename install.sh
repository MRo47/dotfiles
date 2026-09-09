#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/MRo47/dotfiles/main"
NERD_FONT="JetBrainsMono"

WITH_FONTS=0
for arg in "$@"; do
  case "$arg" in
    --fonts) WITH_FONTS=1 ;;
  esac
done

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

# Use the clone's files when run from it; fall back to the repo when piped from curl.
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"

install_file() {
  src="$1"
  dest="$2"
  if [ -n "$SRC_DIR" ] && [ -f "$SRC_DIR/$src" ]; then
    cp "$SRC_DIR/$src" "$dest"
  else
    curl -fsSL "$REPO_RAW/$src" -o "$dest"
  fi
}

install_file starship.toml "$HOME/.config/starship.toml"
install_file bashrc.d/terminal-setup.sh "$HOME/.config/bash/terminal-setup.sh"

if [ "$WITH_FONTS" -eq 1 ]; then
  echo "Installing $NERD_FONT Nerd Font..."
  FONT_DIR="$HOME/.local/share/fonts/$NERD_FONT-Nerd-Font"
  mkdir -p "$FONT_DIR"
  TMP_ZIP="$(mktemp)"
  curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$NERD_FONT.zip" \
    -o "$TMP_ZIP"
  unzip -o -q "$TMP_ZIP" -d "$FONT_DIR"
  rm -f "$TMP_ZIP"
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$FONT_DIR" >/dev/null
  fi
fi