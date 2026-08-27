#!/bin/bash
if [ "$EUID" -eq 0 ]; then
    echo "Do not run install.sh as root."
    exit 1
fi

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Arch setup..."

# Update system
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --needed --noconfirm - < "$SCRIPT_DIR/packages/pacman.txt"

# Copy user configuration
mkdir -p "$HOME/.config"
cp -r "$SCRIPT_DIR/home/.config/." "$HOME/.config/"

mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/Videos/Screenrecords"

# Nano configuration
cp "$SCRIPT_DIR/home/.nanorc" "$HOME/.nanorc"

# Make Hyprland scripts executable
chmod +x "$HOME/.config/hypr/"*.sh

# Make Waybar scripts executable
if [ -d "$HOME/.config/waybar" ]; then
    find "$HOME/.config/waybar" -type f -name "*.sh" -exec chmod +x {} \;
fi

if [ -d "$SCRIPT_DIR/system/sddm/themes/blackwhite" ]; then
    echo "Installing SDDM theme..."

    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r "$SCRIPT_DIR/system/sddm/themes/blackwhite" \
        /usr/share/sddm/themes/

    sudo mkdir -p /etc/sddm.conf.d

    sudo tee /etc/sddm.conf.d/theme.conf >/dev/null <<EOF
[Theme]
Current=blackwhite
EOF

    sudo systemctl enable sddm
fi

# Enable audio
systemctl --user enable pipewire pipewire-pulse wireplumber

# Enable networking
sudo systemctl enable NetworkManager

# Enable Bluetooth
sudo systemctl enable bluetooth

echo "Arch setup completed!"
