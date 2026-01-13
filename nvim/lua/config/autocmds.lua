local utils = require('utils')

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = utils.augroup("checktime"),
  desc = "Check if we need to reload the file when it changed",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = utils.augroup("highlight_yank"),
  desc = "Highlight text on yank",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 })
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = utils.augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = utils.augroup("last_loc"),
  desc = "Go to the last location when opening a buffer",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = utils.augroup("auto_create_dir"),
  desc = "Auto create intermidiate directory when saving a file",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = utils.augroup("env_filetype", {}),
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

-- Set filetype for .code-snippets files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = utils.augroup("code_snippets_filetype", {}),
  pattern = { "*.code-snippets" },
  callback = function()
    vim.opt_local.filetype = "json"
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = utils.augroup("spellcheck", {}),
  pattern = { 'gitcommit', 'markdown', 'tex', 'latex', 'context', 'plaintex' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
    vim.opt_local.complete:append('kspell')
  end
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = utils.augroup("quickfix"),
  pattern = '[^l]*',
  callback = function()
    utils.delete_duplicate_quickfix_entries()
  end
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = utils.augroup("terminal", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})
vim.api.nvim_create_autocmd('BufLeave', {
  group = utils.augroup("terminal", {}),
  callback = function()
    if vim.bo.buftype == 'terminal' then
      vim.g.last_term = vim.api.nvim_get_current_buf()
    else
      vim.g.last_buffer = vim.api.nvim_get_current_buf()
    end
  end
})
vim.api.nvim_create_autocmd('BufDelete', {
  group = utils.augroup("terminal", {}),
  callback = function()
    if vim.bo.buftype == 'terminal' then
      vim.g.last_term = vim.v.null
    else
      vim.g.last_buffer = vim.v.null
    end
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = utils.augroup("misc", {}),
  pattern = 'xml',
  callback = function()
    vim.opt_local.eol = false
  end
})
vim.api.nvim_create_autocmd('VimEnter', {
  group = utils.augroup("misc", {}),
  desc = "Set cursor to beam shape",
  callback = function()
    vim.cmd('silent! echo -ne "\\e[2 q"')
  end,
  once = true,
})

vim.api.nvim_create_autocmd('FileType', {
  group = utils.augroup("no_auto_comment", {}),
  desc = "Avoid auto continue comment on a new line",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = utils.augroup("netrw"),
  pattern = 'netrw',
  callback = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>", group = "netrw", mode = "n" }
    })
    utils.map('n', '<c-l>', '<c-w>l', { buffer = true })
    utils.map(
      'n',
      '<leader>i', function() utils.split_netrw("edit", false) end,
      { buffer = true, nowait = true, desc = "Open file on next tab" }
    )
    utils.map(
      'n',
      '<leader>o',
      function() utils.split_netrw("split", false) end,
      {
        buffer = true,
        nowait = true,
        desc = "Open file in horizontal split on next tab"
      }
    )
    utils.map(
      'n',
      '<leader>v',
      function() utils.split_netrw("vsplit", false) end,
      {
        buffer = true,
        nowait = true,
        desc = "Open file in vertical split on next tab"
      }
    )
    utils.map(
      'n',
      '<leader>I',
      function() utils.split_netrw("edit", true) end,
      {
        buffer = true,
        nowait = true,
        desc = "Open file on next tab and stay in netrw"
      }
    )
    utils.map(
      'n',
      '<leader>O',
      function() utils.split_netrw("split", true) end,
      {
        buffer = true,
        nowait = true,
        desc = "Open file in horizontal split on next tab and stay in netrw"
      }
    )
    utils.map(
      'n',
      '<leader>V',
      function() utils.split_netrw("vsplit", true) end,
      {
        buffer = true,
        nowait = true,
        desc = "Open file in vertical split on next tab and stay in netrw"
      }
    )
  end
})

if vim.g.copilot_available then
  -- Attach Copilot to all loaded buffers after restoring session
  vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = utils.augroup("copilot"),
    callback = function()
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("Copilot! attach")
          end)
        end
      end
    end
  })
end
