# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="xiong-chiamiov-plus"
#ZSH_THEME="cloud"
ZSH_THEME="refined"

plugins=( 
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

fastfetch

# Created by `pipx` on 2024-08-06 21:30:28
export PATH="$PATH:/home/simon/.local/bin"

alias ff="fastfetch"
alias ls="eza -a --color=always --icons=always"
alias vim=nvim
alias v=nvim
alias pull="git pull origin main"
alias commit="git add . && git commit -a -m" 
alias push="git push origin main"
alias c="clear"
alias update="sudo pacman -Syyu"
alias t="tmux"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/simon/.dart-cli-completion/zsh-config.zsh ]] && . /home/simon/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

