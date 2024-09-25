#!/bin/bash
install_pacman=(
neovim
nemo
stow
btop
yay
networkmanager
fzf
eza
ffmpeg
zip
unzip
tmux
)

install_yay=(
qwinff
vesktop
brave-bin
)

sudo pacman -Sy

for PKG1 in "${install_packages[@]}"; do
  sudo pacman -S "$PKG1" 2>&1
done

for PKG1 in "${install_yay[@]}"; do 
  yay -S "$PKG1"
done

rm ~/.config/btop/btop.conf
rm ~/.config/hypr/configs/Keybinds.conf
rm ~/.config/hypr/UserConfigs/UserSettings.conf

# ZSH and oh-my-zsh
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
rm ~/.config/hypr/UserScripts/QuickEdit.sh

# NvChad
mkdir ~/.config/nvim/
rm -r ~/.config/nvim/
cd $HOME
git clone https://github.com/NvChad/starter ~/.config/nvim
nvim
#sleep 60
pkill nvim
rm ~/.config/nvim/lua/plugins/init.lua
rm ~/.config/nvim/lua/chadrc.lua
rm ~/.config/nvim/init.lua

# waybar config files
rm ~/.config/waybar/configs/\[TOP\]\ Default_v3
rm ~/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2

cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default_v3 ~/.config/waybar/configs/
cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2 ~/.config/waybar/configs/

# Tmxu setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cd ~/dotfiles && stow .
echo -e "Installation Completed"
echo -e "Now configuring Wifi"
sudo systemctl start NetworkManager 
sudo systemctl status NetworkManager
sudo nmcli r wifi on
echo -e "configured Wifi"
echo -e "configuring ssh to listen on port 123"
sudo systemctl start sshd.service
sudo systemctl status sshd.service
sudo rm /etc/ssh/sshd_config
sudo cp ~/dotfiles/sshd_config /etc/ssh/
sudo systemctl restart sshd.service
echo -e "configured ssh"
