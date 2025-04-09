/*
avante.nvim - designed to emulate the behaviour of the Cursor AI IDE.

https://nix-community.github.io/nixvim/plugins/avante
https://github.com/yetone/avante.nvim
*/
{
  config,
  lib,
  ...
}: {
  plugins.avante = {
    enable = true;

    settings = let
      inherit (lib.custom.nixvim) hasSnacksModule;

      hasSnacksPicker = hasSnacksModule config "picker";
    in
      {
        behaviour.enable_cursor_planning_mode = true;

        cursor_applying_provider = "groq_applying";

        hints.enabled = false;

        provider = "groq";

        vendors = {
          groq = {
            __inherit_from = "openai";
            api_key_name = "GROQ_API_KEY";
            endpoint = "https://api.groq.com/openai/v1/";
            model = "deepseek-r1-distill-qwen-32b";
            temperature = 0.6;
          };
          # Used in the Cursor planning mode
          groq_applying = {
            __inherit_from = "groq";
            max_tokens = 32768;
            model = "llama-3.3-70b-versatile";
          };
        };
      }
      // lib.optionalAttrs hasSnacksPicker {
        file_selector.provider = "snacks";
      };
  };
}
