{ lib, ... }: 

let
  filePreview = lib.concatStringsSep " " [
    "bat" 
    "-n" 
    "--color=always" 
    "{}"
  ];
  dirPreview = lib.concatStringsSep " " [
    "eza" 
    "--color=always" 
    "--icons" 
    "--hyperlink" 
    "--group-directories-first" 
    "--tree" 
    "--level 3" 
    "{}"
  ];
in 
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Catppuccin Macchiato color scheme for fzf
    # https://github.com/catppuccin/fzf
    colors = {
      "bg+" = "#363a4f";
      # Comment out if a transparent terminal background is used
      bg = "#24273a";
      spinner = "#f4dbd6";
      hl = "#ed8796";
      fg = "#cad3f5";
      header = "#ed8796";
      info = "#c6a0f6";
      pointer = "#f4dbd6";
      marker = "#b7bdf8";
      "fg+" = "#cad3f5";
      prompt = "#c6a0f6";
      "hl+" = "#ed8796";
      selected-bg = "#494d64";
    };

    # Command line options for the CTRL-T keybinding
    fileWidgetOptions = [
      "--preview '[ -d \"{}\" ] && ${dirPreview} || ${filePreview}'"
    ];

    # Command line options for the OPTION-C keybinding
    changeDirWidgetOptions = [
      "--preview '${dirPreview}'"
    ];
  };
}
