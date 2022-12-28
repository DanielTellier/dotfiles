-- Vim globals
vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.maplocalleader = '<space>f'

-- Mappings
local opts = {
  nrsil = { noremap = true, silent = true },
  nr = { noremap = true, silent = false },
  sil = { noremap = false, silent = true },
  nops = { noremap = false, silent = false },
}

--- Open new terminal
vim.keymap.set("n", "<localleader>f", ":FloatermNew <cr>", opts.nrsil)

--- Exit terminal insert mode
vim.keymap.set('t', '<localleader>q', '<c-\\><c-n>', opts.nrsil)

--- Toggle terminal
vim.keymap.set("t", "<localleader>t", '<c-\\><c-n> :FloatermToggle <cr>',
  opts.nrsil)
vim.keymap.set("n", "<localleader>t", ":FloatermToggle <cr>", opts.nrsil)

--- Switch terminals
vim.keymap.set("t", "<localleader>p", '<c-\\><c-n> :FloatermPrev <cr>', opts.nrsil)
vim.keymap.set("t", "<localleader>n", '<c-\\><c-n> :FloatermNext <cr>', opts.nrsil)
vim.keymap.set("n", "<localleader>p", ':FloatermPrev <cr>', opts.nrsil)
vim.keymap.set("n", "<localleader>n", ':FloatermNext <cr>', opts.nrsil)

--- Kill terminal
vim.keymap.set("n", "<localleader>k", ":FloatermKill <cr>", opts.nrsil)
