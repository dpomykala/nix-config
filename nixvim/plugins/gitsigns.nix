_: {
  plugins.gitsigns = {
    enable = true;

    settings = {
      on_attach.__raw = ''
        function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, {buffer = buffer, desc = desc})
          end

          map('n', ']h', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end, 'Next hunk')

          map('n', '[h', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end, 'Previous hunk')

          map('n', ']H', function() gitsigns.nav_hunk('last') end, 'Last hunk')
          map('n', '[H', function() gitsigns.nav_hunk('first') end, 'First hunk')

          map('n', 'ghs', gitsigns.stage_hunk, 'Stage hunk')
          map('v', 'ghs', function()
            gitsigns.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})
          end, 'Stage hunk')

          map('n', 'ghr', gitsigns.reset_hunk, 'Reset hunk')
          map('v', 'ghr', function()
            gitsigns.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})
          end, 'Reset hunk')

          map('n', 'ghu', gitsigns.undo_stage_hunk, 'Unstage hunk')

          map('n', 'ghS', gitsigns.stage_buffer, 'Stage buffer')
          map('n', 'ghR', gitsigns.reset_buffer, 'Reset buffer')

          map('n', 'ghp', gitsigns.preview_hunk, 'Preview hunk')
          map('n', 'ghi', gitsigns.preview_hunk_inline, 'Preview hunk inline')

          map('n', 'ghb', function() gitsigns.blame_line({ full = true }) end, 'Blame line')
          map('n', 'ghB', function() gitsigns.blame() end, 'Blame buffer')

          map('n', 'ghd', gitsigns.diffthis, 'Diff to index')
          map('n', 'ghD', function() gitsigns.diffthis('~') end, 'Diff to parent (~)')

          map('n', '\\gb', gitsigns.toggle_current_line_blame, 'Toggle blame')
          map('n', '\\gd', gitsigns.toggle_deleted, 'Toggle deleted')
          map('n', '\\gw', gitsigns.toggle_word_diff, 'Toggle word diff')

          -- Text object
          map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select hunk')
        end
      '';

      preview_config.border = "rounded";
    };
  };
}
