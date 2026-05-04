local utils = require('utils')
local wk = require("which-key")

wk.add({
  { "<leader>g", group = "git", mode = "n" }
})

local function add_worktree()
  local branch = vim.fn.input("Worktree branch: ")
  local path = vim.fn.input("Worktree path: ", "", "dir")
  local branches = vim.fn.systemlist("git branch -a --format='%(refname:short)'")
  table.insert(branches, 1, "None")
  vim.ui.select(branches, { prompt = "Worktree commitish (optional):" }, function(commitish)
    local cmd = "Git worktree add -b " .. branch .. " " .. path
    if commitish and commitish ~= "None" then
      cmd = cmd .. " " .. commitish
    end
    if branch ~= "" and path ~= "" then
      vim.cmd(cmd)
    end
  end)
end

local function remove_worktree()
  local worktrees = vim.fn.systemlist(
    [[git worktree list | awk 'NR>1 {gsub(/\[|\]/, "", $3); print $1 "," $3}']]
  )
  vim.ui.select(worktrees, { prompt = "Worktree data:" }, function(worktree)
    path, branch = unpack(vim.split(worktree, ","))
    if path ~= "" and branch ~= "" then
      vim.cmd("Git worktree remove " .. path)
      vim.cmd("Git branch -D " .. branch)
    end
  end)
end

utils.map('n', '<leader>gs', "<cmd>Git status<cr>", { desc = "git status" })
utils.map('n', '<leader>gb', "<cmd>Telescope git_branches<cr>", { desc = "git branches" })
utils.map('n', '<leader>gd', "<cmd>DiffviewOpen<cr>", { desc = "Open git diff view" })
utils.map('n', '<leader>gD', "<cmd>DiffviewClose<cr>", { desc = "Close git diff view" })
utils.map('n', '<leader>ga', "<cmd>Git add -u<cr>", { desc = "git add tracked files" })
utils.map('n', '<leader>gA', "<cmd>Git add --all<cr>", { desc = "git add all files" })
utils.map('n', '<leader>gc', "<cmd>Git commit<cr>", { desc = "git commit" })
utils.map('n', '<leader>gu', "<cmd>Git pull<cr>", { desc = "git pull" })
utils.map('n', '<leader>gp', "<cmd>Git push<cr>", { desc = "git push" })
utils.map('n', '<leader>gw', add_worktree, { desc = "git worktree add" })
utils.map('n', '<leader>gW', remove_worktree, { desc = "git worktree remove" })
