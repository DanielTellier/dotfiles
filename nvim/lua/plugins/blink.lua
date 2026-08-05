local dependencies = {}
local src_defaults = {
  "lsp",
  "path",
}
local src_providers = {}
if vim.g.copilot_available then
  dependencies = {
    {
      "fang2hou/blink-copilot",
      opts = {
        max_completions = 3,
        max_attempts = 4,
        kind_name = "Copilot", ---@type string | false
        kind_icon = " ", ---@type string | false
        kind_hl = false, ---@type string | false
        debounce = 200, ---@type integer | false
        auto_refresh = {
          backward = true,
          forward = true,
        },
      },
    },
  }
  table.insert(src_defaults, 1, "copilot")
  src_providers.copilot = {
    name = "copilot",
    module = "blink-copilot",
    score_offset = 100,
    async = true,
  }
else
  vim.list_extend(src_defaults, {"snippets", "buffer"})
end

return {
  --[[
  ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
  ['<C-e>'] = { 'hide', 'fallback' },
  ['<C-y>'] = { 'select_and_accept', 'fallback' },

  ['<Up>'] = { 'select_prev', 'fallback' },
  ['<Down>'] = { 'select_next', 'fallback' },
  ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
  ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

  ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
  ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

  ['<Tab>'] = { 'snippet_forward', 'fallback' },
  ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

  ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
  ]]
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = dependencies,
    opts = {
      sources = {
        default = src_defaults,
        providers = src_providers,
      },
      fuzzy = { implementation = "prefer_rust" },
    },
  },
}
