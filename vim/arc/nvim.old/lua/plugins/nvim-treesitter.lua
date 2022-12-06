require('nvim-treesitter.configs').setup({
  -- one of "all", "maintained" (parsers with maintainers),
  -- or a list of languages
  ensure_installed = "all", 
  sync_install = false,
  ignore_install = { "phpdoc", "tree-sitter-phpdoc" },
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
})
