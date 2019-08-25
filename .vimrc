" *** general settings ***
syntax on

set nocompatible
set number
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,iso-2022-jp
set fileformats=unix,dos,mac
set laststatus=2
set showtabline=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ \[ENC=%{&fileencoding}]\ \[%{&fileformat}]\ %y\ %P

set showcmd
set showmatch
set ruler
set list
set listchars=tab:>\ ,trail:-,nbsp:%,extends:>,precedes:<

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
set tabstop=4
set shiftwidth=4
set softtabstop=0
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
set diffopt=internal,filler,algorithm:histogram,indent-heuristic

" filetype

filetype plugin indent on

autocmd FileType c           setlocal sw=2 sts=2 ts=2 et
autocmd FileType cpp         setlocal sw=2 sts=2 ts=2 et

" mappings

let mapleader = "\<Space>"
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>

nnoremap <silent> <Leader><Enter> :tabnew<CR>:term ++curwin<CR>
tnoremap <silent> <C-w><Leader><Enter> <C-w>:tabnew<CR>:term ++curwin<CR>
nnoremap <silent> <Leader>k :bd<CR>
nnoremap <silent> <C-Right> :tabn<CR>
nnoremap <silent> <C-Left> :tabN<CR>
tnoremap <silent> <C-Right> <C-w>:tabn<CR>
tnoremap <silent> <C-Left> <C-w>:tabN<CR>
tnoremap <silent> <C-w>p <C-w>""
nnoremap x "_x
nnoremap s "_s

" functions
function! CreateCompileCommands()
  if filereadable('CMakeLists.txt') && isdirectory('./build')
    execute 'lcd' . './build'
    call system('cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON')
    call system('compdb list > ../compile_commands.json')
    execute 'lcd' . '../'
  endif
endfunction

" auto commands
" autocmd BufEnter * if bufname('%') == '' && &buftype == '' | let w:bufno = bufnr('%') | bf | execute 'bd' w:bufno | endif
command! CCC call CreateCompileCommands()
autocmd VimEnter * CCC
autocmd BufWritePost CMakeLists.txt CCC

" *** plugin settings ***

" gitgutter
let g:gitgutter_highlight_lines = 1
set updatetime=200
nmap ghu <Plug>GitGutterUndoHunk

" NERDTree
let g:NERDTreeWinSize = 30
let g:NERDTreeShowHidden = 1
let g:NERDTreeChDirMode = 2
" let g:NERDTreeQuitOnOpen = 3
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <silent><Leader>n :NERDTreeToggle<CR>

" rust.vim
let g:rustfmt_autosave = 1

" winresizer
let g:winresizer_vert_resize=2
let g:winresizer_horiz_resize=2

" vim-airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#ale#enabled=1
" let g:airline_statusline_ontop=1
let g:airline_powerline_fonts=1
let g:airline_theme='onedark'

" fzf.vim
nnoremap fb :Buffers<CR>
nnoremap ff :Files<CR>
nnoremap ft :Tags<CR>
nnoremap fg :Rg<CR>
command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})
nnoremap fr :FZFMru<CR>

" ale
let g:ale_linters = {
\   'c'  : ['cppcheck', 'clangtidy', 'clangcheck'],
\   'cpp': ['cppcheck', 'clangtidy', 'clangcheck'],
\   'rust' : [],
\   'python' : [],
\   'go' : [],
\}

" deoplete
let g:deoplete#enable_at_startup = 1

" neosnnipet
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" LanguageClient-neovim
set runtimepath+=~/.vim/pack/completion/start/LanguageClient-neovim
set completefunc=LanguageClient#complete
" set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> gi :call LanguageClient#textDocument_implementation()<CR>
    nnoremap <buffer> <silent> gr :call LanguageClient#textDocument_references()<CR>
    nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    nnoremap <buffer> <silent> F :call LanguageClient#textDocument_formatting()<CR>
  endif
endfunction
autocmd FileType * call LC_maps()
augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted setlocal signcolumn=yes
    autocmd User LanguageClientStopped setlocal signcolumn=auto
augroup END

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['pyls'],
    \ 'cpp': ['clangd'],
    \ 'c': ['clangd'],
    \ 'go': ['gopls'],
    \ }

