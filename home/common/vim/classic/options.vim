" SPECIAL OPTIONS {{{

" Enable file types (detection, plugins and indentation)
filetype plugin indent on

" Enable syntax highlighting
syntax enable

" Set the color scheme
colorscheme catppuccin_macchiato
" }}}

" APPEARANCE {{{

" Hide some markup text (e.g. in Markdown)
set conceallevel=2
" Highlight the current line
set cursorline
" Set special characters to be used in different parts of the window
set fillchars=diff:╱,eob:\ ,fold:\ ,foldclose:,foldopen:,foldsep:\ ,vert:║
" Show special characters in text (e.g. tabs, trailing spaces etc.)
set list
" Set special characters to be displayed when `list` is set
set listchars=extends:…,nbsp:␣,precedes:…,tab:»·,trail:·
" Show line numbers
set number
" Set the maximum number of entries in the pop-up menu
set pumheight=10
" Use line numbers relative to the current line
set relativenumber
" Set the minimum number of lines above and below the cursor
set scrolloff=10
" Set the minimum number of columns to the sides of the cursor
set sidescrolloff=10
" New horizontal splits are created below the current window
set splitbelow
" New vertical splits are created to the right of the current window
set splitright
" Use 24-bit RGB colors
set termguicolors
" Allow the cursor to move past the EOL in the visual block mode
set virtualedit=block
" }}}

" INDENTATION {{{

" Use indentation from the current line when starting a new line
set autoindent
" Use soft tabs (spaces) instead of hard tabs (\t) for indentation
set expandtab
" Align to the closest indentation level when shifting indentation
set shiftround
" Use the 'tabstop' value when shifting indentation with << and >>
set shiftwidth=0
" Auto-indent based on syntax (ignored if indenting via Treesitter)
set smartindent
" Use the `shiftwidth` value (=`tabstop`) when editing with Tab or BS
set softtabstop=-1
" Set the tab width for both soft and hard tabs
set tabstop=2
" }}}

" SEARCHING {{{

" Highlight all of the search results
set hlsearch
" Use case-insensitive search by default (unless `\C` is used)
set ignorecase
" Use incremental search (search as you type)
set incsearch
" Use case-sensitive search if any of the characters are uppercase
set smartcase
" }}}

" WRAPPING {{{

" Indent wrapped lines to match line start
set breakindent
" Break wrapped lines at a character specified in `breakat`
set linebreak
" Don't wrap long lines
set nowrap
" Set the character to be displayed at the start of wrapped lines
set showbreak=↪\ 
" }}}

" STATUS LINE {{{

" Always show the status line
set laststatus=2

" Make sure the airline_symbols variable is defined
if !exists("g:airline_symbols")
    let g:airline_symbols = {}
endif
" Use the powerline symbols (requires nerd font)
let g:airline_powerline_fonts = 1
" Disable the default maxlinenr symbol which causes problems
let g:airline_symbols.maxlinenr = ""
" Set the line number symbol (requires nerd font)
let g:airline_symbols.linenr = " "
" Set the column number symbol (requires nerd font)
let g:airline_symbols.colnr = " "
" Enable the built-in tabline extension
let g:airline#extensions#tabline#enabled = 1
" Show the unique tail for each path in tabline
let g:airline#extensions#tabline#formatter = "unique_tail_improved"
" Use the flame symbol from Powerline Extra Symbols (requires nerd font)
let g:airline#extensions#tabline#left_sep = ""
" Show buffer numbers in tabline
let g:airline#extensions#tabline#buffer_nr_show = 1
" Disable the built-in whitespace extension
let g:airline#extensions#whitespace#enabled = 0
" }}}

" COMMAND LINE {{{

" Disable the default ruler (use the status line instead)
set noruler
" Don't show mode on the command line (use the status line instead)
set noshowmode
" Show the current command (e.g. f, t) on the command line
set showcmd
" Ignore some patterns when expanding wildcards and completing names
set wildignore=*.docx,*.exe,*.flv,*.gif,*.img,*.jpg,*.pdf,*.png,*.pyc,*.xlsx
" Enable a completion menu on the command line
set wildmenu
" Set the command line completion mode
set wildmode=longest:full,full
" }}}

" COMPLETION {{{

" Infer letter cases for insert mode completion (requires `ignorecase`)
set infercase
" Configure insert mode completion
set completeopt=menuone,noselect,fuzzy
" }}}

" FOLDING {{{

" Always start editing a buffer with all folds open
set foldlevelstart=99
" Use indentation based folding
set foldmethod=indent
" }}}

" FILES {{{

" Automatically read a file if it has been changed outside of Vim
set autoread
" Set the directory used for swap files
set directory=$XDG_STATE_HOME/vim/swap//
" Don't make a backup before overwriting a file
set nowritebackup
" Extend the runtime path with the XDG based `after` directory
set runtimepath+=$XDG_CONFIG_HOME/vim/after
" Set the directory used for undo files
set undodir=$XDG_STATE_HOME/vim/undo//
" Use persistent undo history (save to a file)
set undofile
" }}}

" OTHER {{{

" Confirm to save changes before exiting a modified buffer
set confirm
" Allow for switching a buffer without saving (hide an abandoned buffer)
set hidden
" Set the number of history entries for ":" commands and search patterns
set history=10000
" Enable the mouse for all available modes
set mouse=a
" Disable the following:
" - c - messages displayed when using the insert completion menu
" - C - messages displayed when scanning for completion items
" - I - the intro message displayed when starting (Neo)Vim
" - s - messages displayed when wrapping search results
" - W - messages displayed when writing a file
set shortmess+=cCIsW
" Set how long (in ms) to wait for a mapped sequence (default is 1000)
set timeoutlen=300
" Disable the bell sound (set the visual bell to do nothing)
set visualbell t_vb=
" }}}

" vim: foldmethod=marker

