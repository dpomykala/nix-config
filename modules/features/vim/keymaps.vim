" vim: foldmethod=marker

let mapleader=" "
let maplocalleader = ","

" Enter the command mode with `;`
nnoremap ; :
xnoremap ; :
nnoremap : ;
xnoremap : ;

" Keep the selection after changing the indentation
xnoremap < <gv
xnoremap > >gv

" Stop the highlighting of search results
nnoremap <Esc> <Cmd>nohlsearch<CR>

" Move between windows with Ctrl and h, j, k, l, or ;
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-;> <C-w><C-w>

" Leave insert mode
inoremap jj <Esc>
inoremap jk <Esc>
inoremap kj <Esc>

" Use U to redo
nnoremap U <C-r>

" Center the view and open folds when searching or scrolling
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zzzv
nnoremap <C-u> <C-u>zzzv
nnoremap <C-f> <C-f>zzzv
nnoremap <C-b> <C-b>zzzv

" Use H and L to move to the start or end of the line
nnoremap H ^
nnoremap L $

