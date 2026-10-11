# Neovim Configuration
Configured with LSP, AI assistance, and modern tooling.

## Dependencies

### Core

| Binary | Needed for |
| --- | --- |
| `nvim` >= 0.11 | `vim.lsp.config`, `winborder`, treesitter `main` |
| `git` | Plugin cloning, fugitive, diffview |
| `cc`/`gcc` + `make` | Parsers, `telescope-fzf-native`, `tiktoken` |
| `tree-sitter` CLI | nvim-treesitter `main` builds parsers with it |
| `curl`, `unzip`, `tar` | Mason downloads |
| `grep` | `:Mgrep`, `<leader>fw` |
| Clipboard provider | `unnamedplus` — native on macOS, `xclip`/`xsel`/`wl-clipboard` on Linux, OSC 52 over SSH |
| Nerd Font | Devicons, lualine, multi-tree glyphs |

### Per feature

| Binary | Enables | Without it |
| --- | --- | --- |
| `rg` | Live grep, egrepify | `<leader>pg` prompts, `<leader>pe` unmapped |
| `fzf` | `fzf-lua` (not `telescope-fzf-native`) | fzf-lua pickers fail |
| `node` | Copilot ([caveat](#copilot)) | Completion uses `snippets` + `buffer` |
| `python3` | `pyright` | No Python LSP |
| `python` | `:make` (`compiler/python.lua`) | Fails if only `python3` exists |
| `fd` | Faster file finding | Falls back to `rg`, then `find` |
| `tmux` | vim-tmux-navigator panes | `<c-hjkl>` still move windows |
| `cargo` | Building blink.cmp or `tree-sitter-cli` from source | Prebuilt matcher downloaded |

Mason installs `lua_ls`, `pyright`, and `clangd` on first launch. LSP is off by
default; toggle with `<leader>lt`.

### Install examples

macOS ([Homebrew](https://brew.sh)):
```bash
brew install neovim ripgrep node fzf tree-sitter tree-sitter-cli
```

Debian/Ubuntu:
```bash
sudo apt install neovim ripgrep nodejs npm fzf build-essential curl git \
  python3 python-is-python3 xclip
```

Fedora:
```bash
sudo dnf install neovim ripgrep nodejs fzf gcc make curl git python3 xclip
```

Neither packages the `tree-sitter` CLI — add it with `npm install -g
tree-sitter-cli` (or `cargo install tree-sitter-cli`).

Arch:
```bash
sudo pacman -S neovim ripgrep nodejs npm fzf base-devel curl git python \
  tree-sitter tree-sitter-cli xclip
```

Distro Neovim older than 0.11 won't work — use the appimage or tarball.

## Installation

1. Clone to `~/.config/nvim` — dotbot symlinks it, so run `./install` from the
   dotfiles root
2. Install the dependencies above and export any variables below
3. Launch Neovim. First start is slow and may show transient errors while
   plugins, parsers, and servers land; restart once it settles
4. Run `:checkhealth` to verify

## Configuration

### Copilot
Needs a license and Node.js: `export COPILOT_ENABLED="true"`.

Node is **not** found via `PATH`. `init.lua` tries `/usr/bin/node`, then
`/opt/homebrew/opt/node/bin/node`, and disables Copilot silently if neither
exists — for nvm/asdf/Volta, symlink into one or edit `vim.g.node_bin`. Check
with `:lua print(vim.g.copilot_available)`.

### Cache directory
To keep plugins and servers out of `$HOME`, set `XDG_CACHE_HOME`, then
uncomment the `root` / `install_root_dir` lines in `init.lua` and
`lua/plugins/lsp.lua`.

### Development paths
`<leader>pd` reads project roots from `~/.local/share/nvim/dev_paths.json`:
```json
{ "paths": [{ "name": "Dotfiles", "path": "/home/user/.dotfiles" }] }
```

## Layout

| Path | Contents |
| --- | --- |
| `init.lua` | Bootstrap, leader keys, global flags |
| `lua/base_plugins.lua`, `lua/plugins/` | Plugin specs |
| `lua/config/options.lua` | Editor options |
| `lua/config/keymaps/` | Keymaps, auto-loaded per file |
| `lua/utils.lua`, `lua/search.lua` | Shared helpers |
| `after/ftplugin/`, `compiler/` | Filetype and `:make` settings |
| `lazy-lock.json` | Pinned commits — `:Lazy restore` / `:Lazy update` |

| Runtime state | Contents |
| --- | --- |
| `~/.local/share/nvim/lazy/` | Plugins (`:Lazy`) |
| `~/.local/share/nvim/mason/` | Language servers |
| `~/.local/share/nvim/site/parser/` | Treesitter parsers |
| `~/.local/state/nvim/sessions/` | Saved sessions |

## Key Features

- **LSP**: Auto-installed servers (Lua, Python, C/C++), off by default
- **Completion**: blink.cmp with Rust fuzzy matcher
- **AI**: Copilot and CopilotChat with custom prompts
- **Fuzzy Finding**: Telescope with file browser, egrepify, and fzf-lua
- **Git**: vim-fugitive, diffview, worktree helpers
- **Sessions**: Save/restore state (`<leader>sm`/`<leader>sl`)
- **UI**: Custom lualine statusline, onedark, which-key
- **Discoverability**: `<leader>kg` global keymaps, `<leader>kl` buffer-local
