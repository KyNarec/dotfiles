#!/bin/bash
install_pacman=(
neovim
#nemo
stow
btop
yay
fzf
eza
ffmpeg
zip
unzip
tmux
)

install_yay=(
#qwinff
vesktop
brave-bin
)

read -p "$(tput sefat 6)Do you want to configure Wifi?(y/n)$(tput srg0)" wifi

# Pacman candy etc.
mv -f ~/dotfiles/pacman.conf /etc/
mv -f ~/dotfiles/makepkg.conf /etc/

sudo pacman -Syyu --noconfirm

# installing pacman and yay packages
for PKG1 in "${install_pacman[@]}"; do
  sudo pacman -S --noconfirm "$PKG1"
done

for PKG1 in "${install_yay[@]}"; do 
  yay -S --noconfirm "$PKG1"
done

# removing some general configs
rm ~/.config/btop/btop.conf
rm ~/.config/hypr/configs/Keybinds.conf
rm ~/.config/hypr/UserConfigs/UserSettings.conf
rm ~/.config/hypr/UserConfigs/WindowRules.conf

# ZSH and oh-my-zsh
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
rm ~/.config/hypr/UserScripts/QuickEdit.sh

# preparing nvim
mkdir ~/.config/nvim/
rm -r -f ~/.config/nvim/
cd $HOME

# rofi
rm ~/.config/rofi/config-compact.rasi

# waybar config files
rm ~/.config/waybar/configs/\[TOP\]\ Default_v3
rm ~/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2

cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default_v3 ~/.config/waybar/configs/
cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2 ~/.config/waybar/configs/

# Tmxu setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cd ~/dotfiles && stow .
echo -e "$(tput sefat 2)Installation Completed\n$(tput srg0)"

# Wifi
if [ "$wifi" != "y" ]; then
echo -e "$(tput sefat 2)Installing NetworkManager\n$(tput srg0)"
sudo pacman -S --noconfirm networkmanager
echo -e "$(tput sefat 2)Now configuring Wifi\n$(tput srg0)"
sudo systemctl start NetworkManager 
sudo nmcli r wifi on
echo -e "$(tput sefat 2)Configured Wifi\n$(tput srg0)"
fi

# SSH
echo -e "$(tput sefat 2)Configuring ssh to listen on port 123\n$(tput srg0)"
sudo systemctl start sshd.service
sudo rm /etc/ssh/sshd_config
sudo cp ~/dotfiles/sshd_config /etc/ssh/
sudo systemctl restart sshd.service
echo -e "$(tput sefat 2)Configured ssh\n$(tput srg0)
