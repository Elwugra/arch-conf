#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Arch setup..."

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm - < "$SCRIPT_DIR/packages/pacman.txt"

mkdir -p "$HOME/.config"
cp -r "$SCRIPT_DIR/home/.config/"* "$HOME/.config/"
cp "$SCRIPT_DIR/home/.nanorc" "$HOME/.nanorc"

systemctl --user enable pipewire pipewire-pulse wireplumber
sudo systemctl enable NetworkManager

echo "Arch setup completed!"
