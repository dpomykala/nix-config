" vim: foldmethod=marker

let mapleader=" "
let maplocalleader = ","

" Enter the command mode with `;`
nnoremap ; :
xnoremap ; :
nnoremap : ;
xnoremap : ;

" Maintain visual selection when changing indentation
xnoremap < <gv
xnoremap > >gv

" Stop the highlighting of search results
nnoremap <Esc> <Cmd>nohlsearch<CR>

" Use Ctrl + w/h/j/k/l for switching windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-;> <C-w><C-w>

" Quit the insert mode
inoremap jj <Esc>
inoremap jk <Esc>
inoremap kj <Esc>

" Use U for REDO
nnoremap U <C-r>

