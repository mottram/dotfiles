" Jack Mottram <j@ck.mottr.am>
call plug#begin('$XDG_CONFIG_HOME/nvim/plugins')
Plug 'tpope/vim-sensible'
Plug 'rstacruz/vim-opinion'
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-buftabline'
Plug 'benekastah/neomake'
Plug 'ervandew/supertab'
Plug 'freitass/todo.txt-vim'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'itspriddle/vim-marked', { 'for': 'markdown' }
Plug 'junegunn/fzf', {
    \ 'dir': '$HOME/.fzf',
    \ 'do': './install --key-bindings --no-completion --no-update-rc',
    \ 'frozen': 1 
    \ }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'mattly/vim-markdown-enhancements', { 'for': 'markdown' }
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'mrtazz/simplenote.vim'
Plug 'roman/golden-ratio'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
call plug#end()
scriptencoding utf-8
colorscheme gruvbox
set background=dark
let g:gruvbox_sign_column='dark0'
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection='0'
let g:terminal_color_0  = '#282828'
let g:terminal_color_1  = '#cc241d'
let g:terminal_color_2  = '#98971a'
let g:terminal_color_3  = '#d79921'
let g:terminal_color_4  = '#458588'
let g:terminal_color_5  = '#b16286'
let g:terminal_color_6  = '#689d6a'
let g:terminal_color_7  = '#a89984'
let g:terminal_color_8  = '#928374'
let g:terminal_color_9  = '#fb4934'
let g:terminal_color_10 = '#b8bb26'
let g:terminal_color_11 = '#fabd2f'
let g:terminal_color_12 = '#83a598'
let g:terminal_color_13 = '#d3869b'
let g:terminal_color_14 = '#8ec07c'
let g:terminal_color_15 = '#ebdbb2'
runtime! plugin/sensible.vim
runtime! plugin/opinion.vim
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
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:_
set clipboard=unnamed
set splitbelow
set splitright
set termguicolors
set noshowmode
set cursorline
set pastetoggle=<F6>
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let g:mapleader="\<Space>"
nmap <leader>s :w<cr>
nmap <leader><right> :bn<cr>
nmap <leader><left> :bp<cr>
tnoremap <esc><esc> <c-\><c-n>
nmap <leader>x :new<cr>:term<cr>
nmap <leader>F :Sexplore<cr>
nmap <leader>f :Files<cr>
nmap <leader>h :History<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>w :Windows<cr>
nmap <leader>ch :History:<cr>
nmap <leader>m :w<cr>:NeomakeFile<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gwrite<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gn :GitGutterNextHunk<cr>
nmap <silent> <leader>cd :lcd %:h<cr>:pwd<cr>
call yankstack#setup()
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
nmap <leader>y :Yanks<cr>
nmap Y y$
nmap s <Plug>(SneakStreak)
nmap S <Plug>(SneakStreakBackward)
xmap s <Plug>Sneak_s
xmap S <Plug>Sneak_S
nnoremap n nzz
function! MapCR()
    nnoremap <cr> :nohlsearch<cr>:<backspace>
endfunction
call MapCR()
let g:golden_ratio_exclude_nonmodifiable = 1
let g:SimplenoteFiletype='markdown'
let g:SimplenoteListHeight=10
let g:startify_custom_header=[]
let g:startify_enable_special=0
let g:startify_change_to_dir=1
let g:startify_change_to_vcs_root=1
let g:startify_bookmarks=[ 
        \ {'c': '~/dotfiles/nvim/init.vim'},
        \ {'?': '~/Dropbox/todo/todo.txt'},
        \ {'d': '~/dotfiles'},
        \ {'n': '~/notes'}
        \ ]  " Don't use: qeibsvt
let g:startify_list_order = [
        \ ['   Recent files:'],
        \ 'files',
        \ ['   Recent files in the current directory:'],
        \ 'dir',
        \ ['   Bookmarks:'],
        \ 'bookmarks',
        \ ]
let g:fzf_layout={ 'up': '~30%' }
let g:neomake_error_sign={ 'text': 'E', 'texthl': 'WarningMsg' }
let g:neomake_warning_sign={ 'text': 'W', 'texthl': 'WarningMsg' }
let g:neomake_markdown_enabled_makers=['mdl']
let g:neomake_markdown_mdl_maker={ 'args': ['-s', '$HOME/.mdl.rb'] }
let g:neomake_list_height=20
let g:neomake_open_list=2
let g:neomake_python_enabled_makers=['pyflakes']
let g:vim_markdown_frontmatter=1
let g:netrw_liststyle=0
let g:netrw_browse_split=4
let g:netrw_banner=0
hi link SneakPluginScope ErrorMsg
hi link SneakPluginTarget ErrorMsg
hi link SneakStreakMask ErrorMsg
hi link SneakStreakTarget ErrorMsg
source $XDG_CONFIG_HOME/simplenote/config
augroup nvimrc
    autocmd!
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd BufRead,BufNewfile $HOME/Dropbox/Notes/* set filetype=markdown
    autocmd InsertLeave * set nopaste
    autocmd FileType mail set tw=65
    autocmd BufRead COMMIT_EDITMSG execute "normal! 0" | startinsert
    autocmd FileType qf set nobuflisted
augroup END
hi StatusLine guifg=#1d2021 guibg=#bdae93
hi User1 guibg=#1d2021 guifg=#bdae93
hi User2 guibg=#1d2021 guifg=#d65d0e
set statusline=
set statusline+=%2*
set statusline+=%{ModeStatus()}
set statusline+=%{PasteStatus()}
set statusline+=%1*
set statusline+=%F\ 
set statusline+=%2*
set statusline+=%{&filetype}\ 
set statusline+=%{&fileformat}\ 
set statusline+=%{&fileencoding}\ 
set statusline+=%1*
set statusline+=%{FileStatus()}\ 
set statusline+=
set statusline+=%=
set statusline+=%L\ 
function! FileStatus()
  if &filetype ==# 'help'
    return ''
  elseif &readonly
    return '[read only]'
  elseif &modified
    return '[modified]'
  else
    return ''
  endif
endfunction
function! PasteStatus()
    if &paste
        return '[PASTE] '
    en
        return ''
endfunction
function! ModeStatus()
    redraw
    let l:mode = mode()
    if     mode ==# 'n' | return ' '
    elseif mode ==# 'i' | return '[INSERT] '
    elseif mode ==# 'v' | return '[VISUAL] '
    elseif mode ==# 'V' | return '[V-LINE] '
    elseif mode ==# '' | return '[V-BLOCK] '
    elseif mode ==# 'R'  | return '[REPLACE] '
    else                 | return l:mode
    endif
endfunction
