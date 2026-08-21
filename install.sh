#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Arch setup..."

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm - < "$SCRIPT_DIR/packages/pacman.txt"

mkdir -p "$HOME/.config"
cp -r "$SCRIPT_DIR/home/.config/"* "$HOME/.config/"

cp "$SCRIPT_DIR/home/.nanorc" "$HOME/.nanorc"

echo "Installing SDDM theme..."

sudo mkdir -p /usr/share/sddm/themes
sudo cp -r "$SCRIPT_DIR/system/sddm/themes/blackwhite" \
    /usr/share/sddm/themes/

sudo mkdir -p /etc/sddm.conf.d

sudo tee /etc/sddm.conf.d/theme.conf > /dev/null <<EOF
[Theme]
Current=blackwhite
EOF

sudo systemctl enable sddm

systemctl --user enable pipewire pipewire-pulse wireplumber
sudo systemctl enable NetworkManager

echo "Arch setup completed!"
