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
zathura
zathura-pdf-mupdf
)

install_yay=(
#qwinff
vesktop
brave-bin
gearlever
localsend
visual-studio-code-bin
p7zip-gui
)

install_latex=(
texlive
texlive-langgerman
texlive-langeuropean
biber
)

read -p "$(tput setaf 6)Do you want to configure Wifi?(y/n)$(tput sgr0)" wifi
read -p "$(tput setaf 6)Do you want to install fstab file?(y/n)$(tput sgr0)" f 
read -p "$(tput setaf 6)Do you want to configure SSH?(y/n)$(tput sgr0)" ssh
read -p "$(tput setaf 6)Do you want to install texlive (Latex)?(y/n(recomended))$(tput sgr0)" latex 

# Pacman candy etc.
sudo cp -f ~/dotfiles/pacman.conf /etc/
sudo cp -f ~/dotfiles/makepkg.conf /etc/

sudo pacman -Syyu --noconfirm

# installing pacman and yay packages
for PKG1 in "${install_pacman[@]}"; do
  sudo pacman -S --noconfirm "$PKG1"
done

for PKG1 in "${install_yay[@]}"; do 
  yay -S --noconfirm "$PKG1"
done

if [ "$latex" != "y" ]; then
  for PKG1 in "${install_latex[@]}"; do
    sudo pacman -S --noconfirm "$PKG1"
  done
fi
# removing some general configs
rm ~/.config/btop/btop.conf
rm ~/.config/hypr/configs/Keybinds.conf
rm ~/.config/hypr/UserConfigs/UserSettings.conf
rm ~/.config/hypr/UserConfigs/WindowRules.conf

# ZSH and oh-my-zsh
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cp ~/dotfiles/refined.zsh-theme ~/.oh-my-zsh/themes/

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
echo
echo -e "$(tput setaf 2)Installation Completed\n$(tput sgr0)"

# Wifi
if [ "$wifi" != "y" ]; then
echo -e "$(tput setaf 2)Installing NetworkManager\n$(tput sgr0)"
sudo pacman -S --noconfirm networkmanager
echo
echo -e "$(tput setaf 2)Now configuring Wifi\n$(tput sgr0)"
sudo systemctl start NetworkManager 
sudo nmcli r wifi on
echo -e "$(tput setaf 2)Configured Wifi\n$(tput sgr0)"
fi

# fstab
if [ "$f" != "y"]; then
  echo -e "$(tput setaf 2)Copying fstab file\n$(tput sgr0)"
  cp -f ~/dotfiles/fstab /etc/ 
fi

# SSH

if [ "$ssh" != "y" ]; then
echo -e "$(tput setaf 2)Configuring ssh to listen on port 123\n$(tput sgr0)"
sudo systemctl start sshd.service
sudo rm /etc/ssh/sshd_config
sudo cp ~/dotfiles/sshd_config /etc/ssh/
sudo systemctl restart sshd.service
echo -e "$(tput setaf 2)Configured ssh\n$(tput sgr0)"
fi
