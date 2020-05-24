execute pathogen#infect()

set number

set laststatus=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set hlsearch
set incsearch
set ignorecase
set smartcase
set smartindent
set smarttab
set bs=indent,eol,start

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

"syntax on
filetype plugin indent on

autocmd FileType xml setlocal ts=2 sw=2 sts=2

set foldmethod=indent

" Keep all folds open when a file is opened
augroup OpenAllFoldsOnFileOpen
    autocmd!
    autocmd BufRead * normal zR
augroup END

set title

map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

" macros for corrupted STDOUT formatting
let @s = "dd0df'$dF'jd7j"
let @u = "0df'$F'd$"

" Functions and commands
fun! TrimWhitespace()
    let l:save = winsaveview()
    let oldsearch = @/
    :%s/\s\+$//e
    let @/=oldsearch
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

fun! DeColorCode()
    let l:save = winsaveview()
    let oldsearch = @/
    :%s/\[\(\d\d\?\(;\d\d\?\)\?\)\?m//g
    let @/=oldsearch
    call winrestview(l:save)
endfun
command! DeColorCode call DeColorCode()

fun! ToggleWrap()
    if (&wrap == 1)
        set nowrap
    else
        set wrap
    endif
endfun
command! ToggleWrap call ToggleWrap()
