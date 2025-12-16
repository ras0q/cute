#!/bin/sh

REPO_URL="https://raw.githubusercontent.com/ras0q/cute/main/cute"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/cute"
DEST_FILE="$INSTALL_DIR/cute"

mkdir -p "$INSTALL_DIR"
curl -sL "$REPO_URL" -o "$DEST_FILE"

SOURCE_STR="[ -f \"$DEST_FILE\" ] && . \"$DEST_FILE\""

for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$RC_FILE" ]; then
    if ! grep -q "Cute" "$RC_FILE"; then
      printf "\n# Cute\n$SOURCE_STR\n" >> "$RC_FILE"
    fi
  fi
done

echo "Cute installed successfully!"
echo "Please restart your terminal with the following command:"
echo "$ exec \$SHELL -l"
