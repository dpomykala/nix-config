{...}: {
  opts = {
    # APPEARANCE

    # Hide some markup text (e.g. in Markdown)
    conceallevel = 2;
    # Highlight the current line
    cursorline = true;
    # Set special characters to be used in different parts of the window
    fillchars = {
      diff = "╱";
      eob = " ";
      fold = " ";
      foldclose = "";
      foldopen = "";
      foldsep = " ";
      horiz = "═";
      horizdown = "╦";
      horizup = "╩";
      vert = "║";
      verthoriz = "╬";
      vertleft = "╣";
      vertright = "╠";
    };
    # Show live substitute results in a buffer and in a preview window
    inccommand = "split";
    # Show special characters in text (e.g. tabs, trailing spaces etc.)
    list = true;
    # Set special characters to be displayed when `list` is set
    listchars = {
      extends = "…";
      nbsp = "␣";
      precedes = "…";
      tab = "»·";
      trail = "·";
    };
    # Show line numbers
    number = true;
    # Make the pop-up menu slightly transparent
    pumblend = 10;
    # Set the maximum number of entries in the pop-up menu
    pumheight = 10;
    # Use line numbers relative to the current line
    relativenumber = true;
    # Set the minimum number of lines above and below the cursor
    scrolloff = 10;
    # Set the minimum number of columns to the sides of the cursor
    sidescrolloff = 10;
    # Always show the sign column to avoid shifting text
    signcolumn = "yes";
    # New horizontal splits are created below the current window
    splitbelow = true;
    # New vertical splits are created to the right of the current window
    splitright = true;
    # Allow the cursor to move past EOL in the visual block mode
    virtualedit = "block";
    # WARN: Does not play nice with some of noice.nvim / snacks.nvim windows
    # Make floating windows slightly transparent
    # winblend = 10;

    # INDENTATION

    # Use soft tabs (spaces) instead of hard tabs (\t) for indentation
    expandtab = true;
    # Align to the closest indentation level when shifting indentation
    shiftround = true;
    # Use the 'tabstop' value when shifting indentation with << and >>
    shiftwidth = 0;
    # Auto-indent based on syntax (ignored if indenting via Treesitter)
    smartindent = true;
    # Use the `shiftwidth` value (=`tabstop`) when editing with Tab or BS
    softtabstop = -1;
    # Set the tab width for both soft and hard tabs
    tabstop = 2;

    # SEARCHING

    # Use case-insensitive search by default (unless `\C` is used)
    ignorecase = true;
    # Use case-sensitive search if any of the characters are uppercase
    smartcase = true;

    # WRAPPING

    # Indent wrapped lines to match line start
    breakindent = true;
    # Break wrapped lines at a character specified in `breakat`
    linebreak = true;
    # Set the character to be displayed at the start of wrapped lines
    showbreak = "↪ ";
    # Don't wrap long lines
    wrap = false;

    # STATUS/COMMAND LINE

    # Use the global status line
    laststatus = 3;
    # Disable the default ruler (use the status line instead)
    ruler = false;
    # Don't show mode on the command line (use the status line instead)
    showmode = false;
    # Ignore some patterns when expanding wildcards and completing names
    wildignore = "*.docx,*.exe,*.flv,*.gif,*.img,*.jpg,*.pdf,*.png,*.pyc,*.xlsx";
    # Set the command line completion mode
    wildmode = "longest:full,full";

    # COMPLETION

    # Configure insert mode completion
    completeopt = "menuone,noselect,fuzzy";
    # Infer letter cases for insert mode completion (requires `ignorecase`)
    infercase = true;

    # FOLDING

    # Always start editing a buffer with all folds open
    foldlevelstart = 99;

    # NOTE: Other folding options are configured together with Treesitter

    # FILES

    # Use persistent undo history (save to a file)
    undofile = true;
    # Don't make a backup before overwriting a file
    writebackup = false;

    # OTHER

    # Confirm to save changes before exiting a modified buffer
    confirm = true;
    # Enable the mouse for all available modes
    mouse = "a";
    /*
    Disable the following:
    - c - messages displayed when using the insert completion menu
    - I - the intro message displayed when starting (Neo)Vim
    - s - messages displayed when wrapping search results
    - S - the search count message in the command line
    - W - messages displayed when writing a file
    */
    shortmess.__raw = "vim.opt.shortmess:append('cIsSW')";
    # Set how long (in ms) to wait for a mapped sequence (default is 1000)
    timeoutlen = 300;
    # Decrease the update time (this value is used by different plugins)
    updatetime = 200;
  };
}
