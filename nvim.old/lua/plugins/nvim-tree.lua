require("nvim-tree").setup({
  renderer = {
    group_empty = true,
    special_files = {['package.json'] = 2,
                     ['index.ts'] = 1, ['index.tsx'] = 1},
  },
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = '<cr>', action = 'edit' },
        { key = '<c-e>', action = 'edit_in_place' }, -- replace tree explorer
        { key = 'cd', action = 'cd' },
        { key = 'vs', action = 'vsplit' },
        { key = 'sp', action = 'split' },
        { key = '<c-t>', action = 'tabnew' },
        { key = '<', action = 'prev_sibling' },
        { key = '>', action = 'next_sibling' },
        { key = '<s-p>', action = 'parent_node' },
        { key = '<bs>', action = 'close_node' }, -- <bs> = backspace
        { key = '<tab>', action = 'preview' },
        { key = '<s-k>', action = 'first_sibling' },
        { key = '<s-j>', action = 'last_sibling' },
        { key = '<s-i>', action = 'toggle_git_ignored' },
        { key = '<s-h>', action = 'toggle_dotfiles' },
        { key = '<s-r>', action = 'refresh' },
        -- add a file; leaving a trailing `/` will add a directory
        { key = 'a', action = 'create' },
        -- delete a file with prompt
        { key = 'd', action = 'remove' },
        { key = 'r', action = 'rename' },
        -- add/remove file/directory to cut clipboard
        { key = 'x', action = 'cut' },
        -- add/remove file/directory to copy clipboard
        { key = 'c', action = 'copy' },
        { key = 'yn', action = 'copy_name'},
        { key = 'yp', action = 'copy_path'},
        { key = 'ya', action = 'copy_absolute_path'},
        -- add/remove file/directory to cut clipboard
        { key = 'p', action = 'paste' },
        { key = 'u', action = 'dir_up' },
        { key = 'q', action = 'close' }, -- close tree window
        { key = '<s-w>', action = 'collapse_all' }, -- close tree window
        { key = '<s-e>', action = 'expand_all' },
        -- prompt the user to enter a path and then expand 
        -- the tree to match the path
        { key = '<s-e>', action = 'search_node' },
        -- enter vim command mode with the file the cursor is on
        { key = '.', action = 'run_file_command' },
        { key = 'g?', action = 'toggle_help' },
        { key = 'm', action = 'toggle_mark' },
        -- Move all bookmarked nodes into specified location
        { key = 'bmv', action = 'bulk_move' },
      },
    },
  },
})

-- Mappings

local opts = {
  nrsil = { noremap = true, silent = true },
  nr = { noremap = true, silent = false },
  sil = { noremap = false, silent = true },
  nops = { noremap = false, silent = false },
}

vim.keymap.set('n', '<c-n>', ':NvimTreeToggle<cr>', opts.nrsil)
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<cr>', opts.nrsil)
vim.keymap.set('n', '<leader>rr', ':NvimTreeRefresh<cr>', opts.nrsil)
