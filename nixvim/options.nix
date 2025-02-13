{...}: {
  opts = {
    number = true;
    relativenumber = true;

    # Use soft tabs (spaces) instead of hard tabs (\t) for indentation
    expandtab = true;
    # Align to the closest indentation level when shifting indentation
    shiftround = true;
    # Use the 'tabstop' value when shifting indentation with << and >>
    shiftwidth = 0;
    # Auto-indent based on syntax (ignored if indenting via Treesitter).
    smartindent = true;
    # Use the `shiftwidth` value (=`tabstop`) when editing with Tab or BS
    softtabstop = -1;
    # Set the tab width for both soft and hard tabs
    tabstop = 2;

    ignorecase = true;
    smartcase = true;

    cursorline = true;

    scrolloff = 10;

    splitbelow = true;
    splitright = true;

    foldlevel = 99;
  };
}
