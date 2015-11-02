" ~/.config/nvim/init.vim
" Jack Mottram <j@ck.mottr.am>
call plug#begin('$XDG_CONFIG_HOME/nvim/plugins')
Plug 'tpope/vim-sensible'
Plug 'rstacruz/vim-opinion'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'itspriddle/vim-marked', { 'for': 'markdown' }
Plug 'justinmk/vim-sneak'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'ap/vim-buftabline'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'mattly/vim-markdown-enhancements', { 'for': 'markdown' }
Plug 'roman/golden-ratio'
Plug 'junegunn/fzf', { 'dir': '$HOME/.fzf', 'do': './install --key-bindings --no-completion --no-update-rc' }
Plug 'junegunn/fzf.vim'
call plug#end()
scriptencoding utf-8
colorscheme gruvbox
set background=dark
let g:gruvbox_sign_column='dark0'
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection='0'
runtime! plugin/sensible.vim
runtime! plugin/opinion.vim
let g:mapleader="\<Space>"
set shortmess+=I
set history=10000
set tabstop=4
set shiftwidth=4
set softtabstop=4
set numberwidth=4
set undofile
set directory=$XDG_CONFIG_HOME/nvim/temp
set undodir=$XDG_CONFIG_HOME/nvim/undo
set confirm
set wrap
set wildmode=longest:full,list:full
set wildignore+=.DS_Store
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*.swp,*~,._*
set path=**
set suffixesadd+=.markdown,.md,.py,.txt,.sh,.rb,.js,.c,.h,.go,.html,.css
set clipboard=unnamed
set splitbelow
set splitright
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
tnoremap <leader>e <c-\><c-n>
nmap <leader>x :new<cr>:term<cr>
nmap <silent> <leader>cd :lcd %:h<CR>
call yankstack#setup()
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nmap <leader>y :Yanks<cr>
map Y y$
function! MapCR()
    nnoremap <cr> :nohlsearch<cr>:<backspace>
endfunction
call MapCR()
nmap s <Plug>(SneakStreak)
nmap S <Plug>(SneakStreakBackward)
xmap s <Plug>Sneak_s
xmap S <Plug>Sneak_S
let g:fzf_layout = { 'up': '~20%' }
nmap <leader>f :Files<cr>
nmap <leader>m :History<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>w :Windows<cr>
augroup nvimrc
    autocmd!
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd BufRead,BufNewfile ~/Dropbox/Notes/* set filetype=markdown
    autocmd InsertLeave * set nopaste
    autocmd FileType mail set tw=65
augroup END
set statusline=
set statusline+=\ %n.
set statusline+=\ %F\ 
set statusline+=%{&filetype}\ 
set statusline+=%{&fileformat}\ 
set statusline+=%{&fileencoding}\ 
set statusline+=%m\ 
set statusline+=%=
set statusline+=%c\ %l/%L
