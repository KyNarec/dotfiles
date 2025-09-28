#!/bin/bash
install_pacman=(
neovim
#nemo
stow
btop
#yay
fzf
eza
ffmpeg
zip
unzip
tmux
zathura
zathura-pdf-mupdf
zoxide
# for qml lsp
qt6-declarative
qt6-multimedia-ffmpeg
qt6-multimedia
npm
loupe
)

install_yay=(
qwinff
vesktop
brave-bin
gearlever
localsend
visual-studio-code-bin
#p7zip-gui
# tela-circle-icon-theme-all
)

install_latex=(
texlive
texlive-langgerman
texlive-langeuropean
biber
evince
)

read -p "$(tput setaf 6)Do you want to install advanced hyprland configs? May break your Hyprland config... (y/n(recomended))$(tput sgr0)" hypr 
read -p "$(tput setaf 6)Do you want to install Wallpapers?(Will delete all previous wallpapers!)(y/n)$(tput sgr0)" wallpapers
read -p "$(tput setaf 6)Do you want custom german spell checking in neovim?(y/n)$(tput sgr0)" spellcheck
read -p "$(tput setaf 6)Do you want to configure Wifi?(y/n)$(tput sgr0)" wifi
read -p "$(tput setaf 6)Do you want to install fstab file?(y/n)$(tput sgr0)" fstab
read -p "$(tput setaf 6)Do you want to configure SSH?(y/n)$(tput sgr0)" ssh
read -p "$(tput setaf 6)Do you want to install texlive (LaTeX)?(y/n(recomended))$(tput sgr0)" latex 

# Pacman candy etc.
sudo cp -f ~/dotfiles/configs/pacman.conf /etc/
sudo cp -f ~/dotfiles/configs/makepkg.conf /etc/

sudo pacman -Syyu --noconfirm

# installing pacman and yay packages
for PKG1 in "${install_pacman[@]}"; do
  sudo pacman -S --noconfirm "$PKG1"
done

for PKG1 in "${install_yay[@]}"; do 
  yay -S --noconfirm "$PKG1"
done

if [ "$latex" == "y" ]; then
  for PKG1 in "${install_latex[@]}"; do
    sudo pacman -S --noconfirm "$PKG1"
  done
fi
# removing some general configs
rm ~/.config/btop/btop.conf

# ZSH and oh-my-zsh
rm ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cp ~/dotfiles/configs/refined.zsh-theme ~/.oh-my-zsh/themes/

# Kitty config
rm ~/.config/kitty/kitty.conf

if [ "$hypr" == "y" ]; then
echo -e "$(tput setaf 2)Applying custom Hyprland dotfiles\n$(tput sgr0)"

# hyprland configs 
rm ~/.config/hypr/UserScripts/QuickEdit.sh
rm ~/.config/hypr/UserScripts/WallpaperSelect.sh

rm ~/.config/hypr/configs/Keybinds.conf
rm ~/.config/hypr/UserConfigs/UserSettings.conf
rm ~/.config/hypr/UserConfigs/WindowRules.conf

rm ~/.config/hypr/hyprlock.conf

mv ~/.config/hypr/UserScripts/RainbowBorders.sh ~/.config/hypr/UserScripts/RainbowBorders.sh.disabled

# swaync
rm ~/.config/swaync/config.json

# rofi
rm ~/.config/rofi/config-compact.rasi

# waybar config files
rm ~/.config/waybar/configs/\[TOP\]\ Default_v3
rm ~/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2

cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default_v3 ~/.config/waybar/configs/
cp ~/dotfiles/.config/waybar/configs/\[TOP\]\ Default\ Laptop_v2 ~/.config/waybar/configs/

# Wlogout
rm -r ~/.config/wlogout/

echo -e "$(tput setaf 2)Finished applying custom Hyprland dotfiles\n$(tput sgr0)"
fi


if [ "$wallpapers" == "y" ]; then
rm -r ~/Pictures/wallpapers/
cp -r ~/dotfiles/wallpapers/ ~/Pictures/wallpapers
echo -e "$(tput setaf 2)Finished copying wallpapers\n$(tput sgr0)"
fi

# preparing nvim
mkdir ~/.config/nvim/
rm -r -f ~/.config/nvim/

if [ "$spellcheck" == "y" ]; then
  rm -f ~/.local/share/nvim/spell/de.*
fi
cd $HOME

# Tmux setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new-session -d && \
tmux run-shell "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh" && \
tmux kill-server

cd ~/dotfiles && stow .
echo
echo -e "$(tput setaf 2)Installation Completed\n$(tput sgr0)"

# Wifi
if [ "$wifi" == "y" ]; then
echo -e "$(tput setaf 2)Installing NetworkManager\n$(tput sgr0)"
sudo pacman -S --noconfirm networkmanager
echo
echo -e "$(tput setaf 2)Now configuring Wifi\n$(tput sgr0)"
sudo systemctl start NetworkManager 
sudo nmcli r wifi on
echo -e "$(tput setaf 2)Configured Wifi\n$(tput sgr0)"
fi

# fstab
if [ "$fstab" == "y"]; then
  echo -e "$(tput setaf 2)Copying fstab file\n$(tput sgr0)"
  cp -f ~/dotfiles/configs/fstab /etc/ 
fi

# SSH
if [ "$ssh" == "y" ]; then
echo -e "$(tput setaf 2)Configuring ssh to listen on port 123\n$(tput sgr0)"
sudo systemctl start sshd.service
sudo rm /etc/ssh/sshd_config
sudo cp ~/dotfiles/configs/sshd_config /etc/ssh/
sudo systemctl restart sshd.service
echo -e "$(tput setaf 2)Configured ssh\n$(tput sgr0)"
fi

echo -e "$(tput setaf 2)Installation completed. It is recommended to reboot the system.\n$(tput sgr0)"
