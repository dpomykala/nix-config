{...}: {
  plugins.mini.modules.hipatterns = {
    highlighters = {
      fixme = {
        __raw = ''
          require('mini.extra').gen_highlighter.words(
            { 'FIXME' }, 'MiniHipatternsFixme'
          )
        '';
      };
      hack = {
        __raw = ''
          require('mini.extra').gen_highlighter.words(
            { 'HACK' }, 'MiniHipatternsHack'
          )
        '';
      };
      note = {
        __raw = ''
          require('mini.extra').gen_highlighter.words(
            { 'NOTE' }, 'MiniHipatternsNote'
          )
        '';
      };
      todo = {
        __raw = ''
          require('mini.extra').gen_highlighter.words(
            { 'TODO' }, 'MiniHipatternsTodo'
          )
        '';
      };

      hex_color = {
        __raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
      };
    };
  };
}
