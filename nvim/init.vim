" ~/.nvim/nvimrc
" Jack Mottram <j@ck.mottr.am>
call plug#begin('~/.nvim/plugins')
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
Plug 'tpope/vim-eunuch'
Plug 'vim-scripts/renamer.vim'
Plug 'ap/vim-buftabline'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'mattly/vim-markdown-enhancements', { 'for': 'markdown' }
Plug 'kien/ctrlp.vim'
call plug#end()
scriptencoding utf-8
augroup vimrc
    autocmd!
augroup END
colorscheme gruvbox
set background=dark
let g:gruvbox_sign_column='dark0'
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection='0'
runtime! plugin/sensible.vim
runtime! plugin/opinion.vim " Required to override vim-opinion
let g:mapleader=','
set shortmess+=I
set history=10000
set tabstop=4
set shiftwidth=4
set softtabstop=4
set numberwidth=4
set undofile
set directory=~/.nvim/temp
set undodir=~/.nvim/undo
set confirm
set wrap
set wildmode=longest:full,list:full
set wildignore+=.DS_Store
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*.swp,*~,._*
set path=**
set suffixesadd+=.markdown,.md,.py,.txt,.sh,.rb,.js,.c,.h,.go,.html,.css
set clipboard=unnamed
call yankstack#setup()
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nmap <leader>y :Yanks<cr>
map Y y$
nmap <silent> <leader>cd :lcd %:h<CR>
function! MapCR()
    nnoremap <cr> :nohlsearch<cr>:<backspace>
endfunction
call MapCR()
nmap s <Plug>(SneakStreak)
nmap S <Plug>(SneakStreakBackward)
xmap s <Plug>Sneak_s
xmap S <Plug>Sneak_S
let g:ctrlp_match_window = 'top'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path = 0
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
  let g:ctrlp_use_caching = 0
endif
nmap <leader>m :CtrlPMRUFiles<cr>
nmap <leader>f :CtrlP<cr>
let g:buffergator_viewport_split_policy='T'
tnoremap <leader>e <c-\><c-n>
nmap <leader>x :new<cr>:term<cr>
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
autocmd vimrc BufNewFile,BufReadPost *.md set filetype=markdown
autocmd vimrc BufRead,BufNewfile ~/Dropbox/Notes/* set filetype=markdown
autocmd vimrc InsertLeave * set nopaste
autocmd vimrc FileType mail set tw=65
set splitbelow
set splitright
set statusline=
set statusline+=\ %n.
set statusline+=\ %F\ 
set statusline+=%{&filetype}\ 
set statusline+=%{&fileformat}\ 
set statusline+=%{&fileencoding}\ 
set statusline+=%m\ 
set statusline+=%=
set statusline+=%c\ %l/%L
