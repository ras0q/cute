#!/bin/sh

REPO_URL="https://raw.githubusercontent.com/ras0q/cute/main/cute"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/cute"
DEST_FILE="$INSTALL_DIR/cute"

mkdir -p "$INSTALL_DIR"
curl -sL "$REPO_URL" -o "$DEST_FILE"

SOURCE_STR="[ -f \"$DEST_FILE\" ] && . \"$DEST_FILE\""

for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$RC_FILE" ]; then
    if ! grep -q "cute" "$RC_FILE"; then
      printf "\n# cute\n$SOURCE_STR\n" >> "$RC_FILE"
    fi
  fi
done
