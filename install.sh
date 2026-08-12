set -e 

echo "Starting Arch setup"

sudo pacman -Syu --noconfirm
 
sudo pacman -S --needed -noconfirm - < packages/pacman.txt

mkdir -p "$HOME/.config"

cp -r home/.config/* "$HOME/.config"

systemctl --user enable pipewire pipewire-pulse wireplumber 

sudo systemctl enable NetworkManager

echo "Arch setup completed"
