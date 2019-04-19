
syntax on

set nocompatible
set number
set fenc=utf-8
set laststatus=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ \[ENC=%{&fileencoding}]%P

set showmatch
set ruler
set list
set listchars=tab:\ >,trail:-,nbsp:%,eol:↲,extends:>,precedes:<

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescrolloff=16
set sidescroll=1

set confirm
set hidden
set autoread

set hlsearch
set incsearch
set ignorecase
set smartcase

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

set clipboard=unnamed,unnamedplus
set mouse=a
set shellslash
" set iminsert=2

set wildmenu wildmode=list:longest,full
set history=10000

set visualbell t_vb=
set noerrorbells

set modifiable
set write

set directory=~/.vim/tmp

"mappings

nmap <Esc><Esc> :nohlsearch<CR><Esc>

"plugin settings

let g:gitgutter_highlight_lines = 1
set updatetime=250

let NERDTreeShowHidden = 1
let g:nerdtree_tabs_open_on_console_startup=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

