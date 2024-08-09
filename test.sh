#!/bin/bash/
install_packages=(
  thunar
)



for PKG1 in "${install_packages[@]}"; do
sudo pacman -Sy "$PKG1" 
done

