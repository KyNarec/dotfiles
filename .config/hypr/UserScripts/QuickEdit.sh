#!/bin/bash
# Rofi menu for Quick Edit / View of Settings (SUPER E)

# define your preferred text editor and terminal to use
editor=nvim
tty=kitty

configs="$HOME/.config/hypr/configs"
UserConfigs="$HOME/.config/hypr/UserConfigs"

menu(){
  printf "1. view Env-variables\n"
  printf "2. view Window-Rules\n"
  printf "3. view Startup_Apps\n"
  printf "4. view User-Keybinds\n"
  printf "5. view Monitors\n"
  printf "6. Convert Files\n"
  printf "7. view Laptop-Keybinds\n"
  printf "8. view User-Settings\n"
  printf "9. view Workspace-Rules\n"
  printf "10. view Default-Settings\n"
  printf "11. view Default-Keybinds\n"
  printf "12. General Notes\n"
}

main() {
    choice=$(menu | rofi -i -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)
    case $choice in
        1)
            $tty $editor "$UserConfigs/ENVariables.conf"
            ;;
        2)
            $tty $editor "$UserConfigs/WindowRules.conf"
            ;;
        3)
            $tty $editor "$UserConfigs/Startup_Apps.conf"
            ;;
        4)
            $tty $editor "$UserConfigs/UserKeybinds.conf"
            ;;
        5)
            $tty $editor "$UserConfigs/Monitors.conf"
            ;;
        7)
            $tty $editor "$UserConfigs/Laptops.conf"
            ;;
        8)
            $tty $editor "$UserConfigs/UserSettings.conf"
            ;;
        9)
            $tty $editor "$UserConfigs/WorkspaceRules.conf"
            ;;
	10)
            $tty $editor "$configs/Settings.conf"
            ;;
        11)
            $tty $editor "$configs/Keybinds.conf"
            ;;
	6)
	     "/bin/qwinff"
	    ;;
	12)
	    $tty $editor "$HOME/tips.txt"
	    ;;
        *)
            ;;
    esac
}

main
