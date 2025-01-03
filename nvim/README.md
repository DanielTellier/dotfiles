# nvim-config
Neovim configuration

# Setup
Plugins used, placed at ~/.local/share/nvim/plugged when call `:PlugInstall`:
- Plugin Manager **vim-plug**, placed at ~/.local/share/site/autoload/plug.vim
  (https://github.com/junegunn/vim-plug.git):
```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
- Tpope:
    - https://github.com/tpope/vim-commentary.git
    - https://github.com/tpope/vim-fugitive.git
    - https://github.com/tpope/vim-obsession.git
    - https://github.com/tpope/vim-repeat.git
    - https://github.com/tpope/vim-surround.git
    - https://github.com/tpope/vim-unimpaired.git
- Misc:
    - https://github.com/windwp/nvim-autopairs.git
    - https://github.com/nvim-treesitter/nvim-treesitter.git
    - https://github.com/navarasu/onedark.nvim.git
    - https://github.com/nvim-lualine/lualine.nvim.git
- Copilot (If available):
    - https://github.com/zbirenbaum/copilot.lua.git
    - https://github.com/zbirenbaum/copilot-cmp.git
    - https://github.com/hrsh7th/nvim-cmp.git
    - https://github.com/nvim-lua/plenary.nvim.git
    - https://github.com/CopilotC-Nvim/CopilotChat.nvim.git
