{...}: {
  opts = {
    # Highlight the current line
    cursorline = true;
    # Show line numbers
    number = true;
    # Use line numbers relative to the current line
    relativenumber = true;
    # Set the minimum number of lines above and below the cursor
    scrolloff = 10;
    # Set the minimum number of columns to the sides of the cursor
    sidescrolloff = 10;

    # Indent wrapped lines to match line start
    breakindent = true;
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

    # Use case-insensitive search by default (unless `\C` is used)
    ignorecase = true;
    # Use case-sensitive search if any of the characters are uppercase
    smartcase = true;

    # Disable the default ruler (use the status line instead)
    ruler = false;
    # Don't show mode on the command line (use the status line instead)
    showmode = false;
    # Ignore some patterns when expanding wildcards and completing names
    wildignore = "*.docx,*.exe,*.flv,*.gif,*.img,*.jpg,*.pdf,*.png,*.pyc,*.xlsx";
    # Set the command line completion mode
    wildmode = "longest:full,full";

    foldlevel = 99;
    # New horizontal splits are created below the current window
    splitbelow = true;
    # New vertical splits are created to the right of the current window
    splitright = true;
    # Set how long (in ms) to wait for a mapped sequence (default is 1000)
    timeoutlen = 300;
  };
}
