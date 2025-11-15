if not vim.g.claude_available then
  return {}
end

return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  keys = {
    {
      '<leader>ck',
      '<cmd>ClaudeCode<cr>',
      desc = 'Toggle Claude Code',
      mode = 'n',
    },
  },
  config = function()
    require("claude-code").setup()
  end,
}
