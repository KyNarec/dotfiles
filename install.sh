#!/bin/bash
bashinstall_packages=(
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
mkdir ~/.config/nvim/
rm -r ~/.config/nvim/
cd $HOME
git clone https://github.com/NvChad/starter ~/.config/nvim
nvim
sleep 120
rm ~/.config/nvim/lua/plugins/init.lua
rm ~/.config/nvim/lua/chadrc.lua
cd
cd ~/dotfiles && stow .
