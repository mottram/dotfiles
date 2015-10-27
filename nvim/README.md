# Neovim configuration

## Setup

1. `git clone https://github.com/mottram/dotfiles.git ~/dotfiles`
2. `ln -s ~/dotfiles/nvim ~/.config/nvim`
3. `mkdir -p ~/.nvim/{temp,undo,view,autoload}`
4. `curl -fLo ~/.nvim/autoload/plug.vim --create dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
5. `nvim +PlugInstall +qall`
