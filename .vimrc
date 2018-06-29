" General
set history=500

filetype plugin on
filetype indent  on

set autoread

" VIM UI
set so=7
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set wildmenu

set ruler
set number

set cmdheight=2

set hid

set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase

set smartcase

set hlsearch

set incsearch

set lazyredraw

set magic

set showmatch

set mat=2

set noerrorbells
set novisualbell
set t_vb=
set tm=500

if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

set foldcolumn=1

" Colors and Fonts
syntax enable

if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry

set background=dark

if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablevel=%M\ %t
endif

set encoding=utf8

set ffs=unix,dos,mac

" Files, backups, and undo

set nobackup
set nowb
set noswapfile

" Text, tab, and indents

set expandtab
set smarttab

set shiftwidth=4
set tabstop=4
set lbr
set tw=500

set ai
set si
set wrap

" Visual mode

vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@\<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@\<CR><CR>

" Moving around tabs, windows, and buffers

map <space> /
map <c-space> ?

map <silent> <leader><cr> :noh<cr>

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Status line

set laststatus=2

set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Helper functions

function! HasPaste()
    if &paste
        return 'PASTE MODE '
    endif
    return ''
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

highlight default ExtraWhitespace ctermbg=darkred guibg=darkred
autocmd ColorScheme * highlight default ExtraWhitespace ctermbg=darkred guibg=darkred
autocmd BufRead,BufNew * match ExtraWhitespace /\\\@<![\u3000[:space:]]\+$/

