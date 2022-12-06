-- Vim globals
vim.g.maplocalleader = '<space>z'

-- Vim cmds
vim.cmd([[
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
]])

vim.cmd('command! -nargs=* -bang Rgf call RipgrepFzf(<q-args>, <bang>0)')

-- Mappings
local map = vim.keymap.set
local opts = { noremap = false, silent = false }

map('n', '<localleader>r', ':Rgf<space>',
  { noremap = true, silent = false})

map('n', '<localleader><tab>', '<plug>(fzf-maps-n)', opts)
map('x', '<localleader><tab>', '<plug>(fzf-maps-x)', opts)
map('o', '<localleader><tab>', '<plug>(fzf-maps-o)', opts)

--- Fzf insert mode completion
map('i', '<localleader>w', '<plug>(fzf-complete-word)', opts)
map('i', '<localleader>p', '<plug>(fzf-complete-path)', opts)
map('i', '<localleader>l', '<plug>(fzf-complete-line)', opts)

--- Word completion with custom popup
map('i', "<expr> <localleader>c",
  "fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})",
  { noremap = true, silent = false })
