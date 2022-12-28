vim.cmd([[packadd packer.nvim]])
vim.cmd([[
  augroup packer_compile
    autocmd!
    autocmd BufWritePost plugins.lua | PackerClean
    autocmd BufWritePost */plugins/*.lua | PackerClean
    autocmd BufWritePost plugins.lua | PackerSync
    autocmd BufWritePost */plugins/*.lua | PackerSync
  augroup end
]])

require('packer').startup(function() 
  use 'wbthomason/packer.nvim'

  -- Buffers & Statusline
  use { 'nvim-lualine/lualine.nvim',
        config = function() require('plugins.lualine') end }
  use 'moll/vim-bbye'
  use { 'noib3/nvim-cokeline', requires = { 'kyazdani42/nvim-web-devicons' },
        config = function() require('plugins.nvim-cokeline') end }

  -- Navigation
  use { 'kyazdani42/nvim-tree.lua',
        config = function() require('plugins.nvim-tree') end }
  
  -- Git
  use 'tpope/vim-fugitive'

  -- LSP
  use { 'neovim/nvim-lspconfig',
        config = function() require('plugins.nvim-lspconfig') end }
  -- use { 'neoclide/coc.nvim', branch = 'release',
  --       config = function() require('plugins.coc') end }
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use { 'glepnir/lspsaga.nvim',
        config = function() require('plugins.lspsaga') end }
  use { 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim' },
        config = function() require('plugins.null-ls') end } 
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        config = function() require('plugins.nvim-treesitter') end }

  -- Utils
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use { 'windwp/nvim-autopairs', 
	config = function() require('plugins.nvim-autopairs') end }
  use { 'voldikss/vim-floaterm',
        config = function() require('plugins.vim-floaterm') end }
  use 'editorconfig/editorconfig-vim' 
  use { 'prettier/vim-prettier', run = 'npm install' }
  -- use 'mfussenegger/nvim-dap'

  -- Themes
  use 'shaunsingh/nord.nvim'
 
  -- Fuzzy Finder
  use 'junegunn/fzf'
  use { 'junegunn/fzf.vim',
        config = function() require('plugins.fzf') end }
end)
