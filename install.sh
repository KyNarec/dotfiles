#!/bin/bash
install_packages=(
neovim
qwinff
nemo
stow
)

sudo pacman -Sy

for PKG1 in "${install_packages[@]}"; do
sudo pacman -S "$PKG1"
done

rm ~/.config/hypr/configs/Keybinds.conf
rm ~/.zshrc
rm ~/.config/hypr/UserScripts/QuickEdit.sh
# NvChad
mkdir ~/.config/nvim/
rm -r ~/.config/nvim/
cd $HOME
git clone https://github.com/NvChad/starter ~/.config/nvim
nvim
sleep 60
pkill nvim
rm ~/.config/nvim/lua/plugins/init.lua
rm ~/.config/nvim/lua/chadrc.lua
cd
# waybar config files
rm ~/.config/waybar/configs/\[TOP\]\ Default_v3
rm ~/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2

cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default_v3 ~/.config/waybar/configs/
cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2 ~/.config/waybar/configs/

cd ~/dotfiles && stow .
