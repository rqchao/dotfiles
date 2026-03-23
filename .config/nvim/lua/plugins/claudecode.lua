return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    -- Use the same Vertex AI configuration as your claudev alias
    terminal_cmd = "env CLAUDE_CODE_USE_VERTEX=1 CLOUD_ML_REGION=us-east5 ANTHROPIC_VERTEX_PROJECT_ID=dev-sandbox-334901 claude",

    -- Send/Focus Behavior
    focus_after_send = false,

    -- Terminal Configuration
    terminal = {
      split_side = "right",
      split_width_percentage = 0.30,
      provider = "auto",
      auto_close = true,
    },
  },
}
