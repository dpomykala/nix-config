_: {
  plugins.avante = {
    enable = true;

    settings = {
      behaviour.enable_cursor_planning_mode = true;

      cursor_applying_provider = "groq_applying";

      file_selector.provider = "snacks";

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
    };
  };
}
