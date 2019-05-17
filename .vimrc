" *** general settings ***
syntax on

set nocompatible
set number
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,iso-2022-jp
set fileformats=unix,dos,mac
set laststatus=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ \[ENC=%{&fileencoding}]\ \[%{&fileformat}]\ %y\ %P


set showcmd
set showmatch
set ruler
set list
set listchars=tab:\ >,trail:-,nbsp:%,extends:>,precedes:<

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

set wildmenu wildmode=list:longest,full
set history=10000

set visualbell t_vb=
set noerrorbells

set modifiable
set write

set directory=~/.vim/tmp

set completeopt=menu,noselect,longest

" filetype

filetype plugin indent on

autocmd FileType c           setlocal sw=2 sts=2 ts=2 et
autocmd FileType cpp         setlocal sw=2 sts=2 ts=2 et

" mappings

nmap <Esc><Esc> :nohlsearch<CR><Esc>


" *** plugin settings ***

" gitgutter
let g:gitgutter_highlight_lines = 1
set updatetime=250
nmap ghu <Plug>GitGutterUndoHunk

" NERDTree
let g:NERDTreeWinSize = 20
let g:NERDTreeShowHidden = 1
let g:NERDTreeChDirMode = 2

nnoremap <silent><C-e> :NERDTreeToggle<CR>
autocmd VimEnter *
\  if argc() == 0 && !exists("s:std_in") |
\    let g:nerdtree_tabs_open_on_console_startup = 1 |
\  endif
autocmd bufenter *
\  if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) |
\    q |
\  endif

" vim-clang
let g:clang_c_options = '-std=c11 -stdlib=libgcc'
let g:clang_cpp_options = '-std=c++14 -stdlib=libstdc++'
let g:clang_load_if_clang_dotfile = 1
let g:clang_check_syntax_auto = 1
" let g:clang_format_auto = 1
let g:clang_use_library = 1
let g:clang_include_sysheaders_from_gcc = 1
let g:clang_sh_exec = 'bash'

" vim-racer
let g:racer_cmd = '$HOME/.cargo/bin/racer'
let g:racer_experimental_completer = 1
let g:rustfmt_autosave = 1

autocmd FileType rust nmap gd <Plug>(rust-def)
autocmd FileType rust nmap gs <Plug>(rust-def-split)
autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)

" winresizer

let g:winresizer_vert_resize=2
let g:winresizer_horiz_resize=2
