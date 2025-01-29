# nvim-config
Neovim configuration

# Setup
Plugins used placed at ~/.local/share/nvim/plugged when call `:PlugInstall`:
- Plugin Manager placed at ~/.local/share/nvim/site/autoload/plug.vim ([vim-plug](https://github.com/junegunn/vim-plug.git)):
```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

If you have a Copilot license setup on your system put the following in your ~/.bashrc:
`export COPILOT_ENABLED="true"`

- Tpope:
    - [vim-commentary](https://github.com/tpope/vim-commentary.git)
    - [vim-fugitive](https://github.com/tpope/vim-fugitive.git)
    - [vim-obsession](https://github.com/tpope/vim-obsession.git)
    - [vim-repeat](https://github.com/tpope/vim-repeat.git)
    - [vim-surround](https://github.com/tpope/vim-surround.git)
    - [vim-unimpaired](https://github.com/tpope/vim-unimpaired.git)
- Misc:
    - [nvim-autopairs](https://github.com/windwp/nvim-autopairs.git)
    - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter.git)
    - [onedark.nvim](https://github.com/navarasu/onedark.nvim.git)
    - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim.git)
- Copilot (If available):
    - [copilot.lua](https://github.com/zbirenbaum/copilot.lua.git)
    - [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp.git)
    - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp.git)
    - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim.git)
    - [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim.git)
