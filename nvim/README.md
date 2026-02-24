# Neovim Configuration
Configured with LSP, AI assistance, and modern tooling.

## Prerequisites

### Required Binaries
- **Neovim** (>= 0.8)
- **Git** - for plugin management and neogit
- **Node.js** - for Copilot (auto-detected at `/usr/bin/node` or `/opt/homebrew/opt/node/bin/node`)
- **make** - for telescope-fzf-native compilation
- **gcc** - for C/C++ development and treesitter parsers

### Optional Tools
- **ripgrep** (`rg`) - enhanced grep performance
- **fd** - faster file finding
- **ctags** - for code navigation

## Setup

### Lazy
- Plugins used placed at ~/.local/share/nvim/lazy when call `:Lazy`
- Plugins used can be found at:
    - <PROJECT_ROOT>/lua/base_plugins.lua
    - <PROJECT_ROOT>/lua/plugins/

### Copilot
If you have a GitHub Copilot license:
```bash
export COPILOT_ENABLED="true"
```

### LSP Control
To toggle LSP server in a given file: `<leader>lt`

### Cache Directory (Optional)
To store plugins/LSP servers outside home directory:
```bash
export XDG_CACHE_HOME="/tmp/$USER/.cache"
```

## Installation

1. Clone this config to `~/.config/nvim`
2. Set environment variables in `~/.bashrc` or `~/.zshrc`
3. Launch Neovim - plugins will auto-install via lazy.nvim
4. Run `:checkhealth` to verify setup

## Key Features

- **Plugin Management**: lazy.nvim with modular configuration
- **LSP**: Automatic language server installation (Lua, Python, C/C++)
- **AI Integration**: GitHub Copilot with custom prompts
- **Fuzzy Finding**: Telescope with file browser
- **Session Management**: Save/restore workspace state
- **Git Integration**: Neogit and diffview
- **Modern UI**: Custom statusline and dashboard

## Storage Locations

- **Plugins**: `~/.local/share/nvim/lazy/`
- **LSP Servers**: `~/.local/share/nvim/mason/`
- **Sessions**: `~/.local/state/nvim/sessions/`
