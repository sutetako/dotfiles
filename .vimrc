" *** general settings ***
syntax on

set number
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp,iso-2022-jp
set fileformats=unix,dos,mac
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
set shiftwidth=2
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

" colorshema
colorscheme ron

" highlight
hi DiffAdd    ctermfg=None ctermbg=53
hi DiffDelete ctermfg=None ctermbg=52


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
nnoremap <silent> <Leader>r :sign unplace *<CR>:w<CR>
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

function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line('$'), a:maxheight]), a:minheight]) . 'wincmd _'
endfunction

" auto commands
" autocmd BufEnter * if bufname('%') == '' && &buftype == '' | let w:bufno = bufnr('%') | bf | execute 'bd' w:bufno | endif
command! CCC call CreateCompileCommands()
augroup auCCC
  autocmd!
  autocmd VimEnter * CCC
  autocmd BufWritePost CMakeLists.txt CCC
augroup END

" filetype

filetype plugin indent on

augroup auFileType
  autocmd!
  autocmd FileType c      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType cpp    setlocal sw=2 sts=2 ts=2 et
  autocmd FileType go     setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType python setlocal sw=4 sts=4 ts=4 et
  autocmd FileType qf     call AdjustWindowHeight(3, 10)
augroup END

" *** plugin settings ***

" gitgutter
let g:gitgutter_highlight_lines = 1
set updatetime=200
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

" NERDTree
let g:NERDTreeWinSize = 30
let g:NERDTreeShowHidden = 1
let g:NERDTreeChDirMode = 2
" let g:NERDTreeQuitOnOpen = 3
augroup nerdtree
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
nnoremap <silent><Leader>n :NERDTreeToggle<CR>

" rust.vim
let g:rustfmt_autosave = 1

" winresizer
let g:winresizer_vert_resize=2
let g:winresizer_horiz_resize=2

" vim-airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
" let g:airline_statusline_ontop=1
let g:airline_powerline_fonts=1
let g:airline_theme='onedark'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = ' '

" fzf.vim
let $FZF_DEFAULT_OPTS="--layout=reverse"
let g:fzf_preview_window = ['down:50%', 'ctrl-/']
let g:fzf_layout = {'window': { 'width': 0.95, 'height': 0.9 }}
nnoremap fb :Buffers<CR>
nnoremap ff :Files<CR>
nnoremap ft :Tags<CR>
nnoremap fg :Rg<CR>
nnoremap fr :History<CR>
command! -bang -nargs=* Rg call fzf#vim#grep(
\  'rg --glob "!{tags}" --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
\  fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" neosnippet
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <expr><C-k> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-y>" : ""
smap <expr><C-k> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-y>" : ""

if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" asyncomplete
" let g:asyncomplete_log_file = expand('~/.vim/tmp/asyncomplete.log')

" asyncomplete-neosnippet.vim
augroup asyncomplete_neosnippet_setting
    au!
    autocmd VimEnter * call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
    \ 'name': 'neosnippet',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
    \ }))
augroup END

" vim-lsp
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_echo_delay = 100
let g:lsp_signs_priority = 11
" let g:lsp_preview_doubletap = 0
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/.vim/tmp/vim-lsp.log')


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <f2> <plug>(lsp-rename)
    nmap <silent> F <plug>(lsp-document-format)
    nmap <silent> ]e <plug>(lsp-next-error)
    nmap <silent> [e <plug>(lsp-previous-error)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" vim-lsp-settings
let g:lsp_settings_servers_dir='~/.lsp_servers'
let g:lsp_settings = {
\   'pylsp-all': {
\     'workspace_config': {
\       'pylsp': {
\         'plugins': {
\           'pycodestyle': {
\             'ignore': ["E501"]
\           }
\         }
\       }
\     }
\   }
\ }

