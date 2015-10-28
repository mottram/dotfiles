# Neovim configuration

## Setup

1. `git clone https://github.com/mottram/dotfiles.git ~/dotfiles`
2. `ln -s ~/dotfiles/nvim $XDG_CONFIG_HOME/nvim`
3. `mkdir -p $XDG_CONFIG_HOME/nvim/{temp,undo,view,autoload}`
4. `curl -fLo $XDG_CONFIG_HOME/autoload/plug.vim --create dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
5. `nvim +PlugInstall +qall`
