local utils = require('utils')
local wk = require("which-key")

wk.add({
  { "<leader>g", group = "git", mode = "n" }
})

local function add_worktree()
  local local_branch_name = vim.fn.input("Local branch name (optional): ", "", "dir")
  local path = vim.fn.input("Path: ", local_branch_name, "dir")
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if not utils.starts_with(path, { "/", "../" }) then
    path = git_root .. "/../" .. path
  end
  local branches = vim.fn.systemlist("git branch -a --format='%(refname:short)'")
  local prompt = "Existing branch"
  if local_branch_name ~= "" then
    prompt = prompt .. " (optional)"
  end
  table.insert(branches, 1, "None")
  vim.ui.select(branches, { prompt = "Worktree commitish (optional):" }, function(branch)
    local cmd = "Git worktree add "
    if local_branch_name ~= "" and path ~= "" then
      cmd = "-b " .. local_branch_name .. " " .. path
      if branch and branch ~= "None" then
        cmd = cmd .. " " .. branch
      end
      vim.cmd(cmd)
    elseif path ~= "" and branch and branch ~= "None" then
      vim.cmd(cmd .. path .. " " .. branch)
      print("Worktree created at " .. path .. " for branch " .. branch)
    else
      print("No worktree specified for creation.")
    end
  end)
end

local function remove_worktree()
  local worktrees = vim.fn.systemlist(
    [=[
    git worktree list | awk '
      NR > 1 {
        ref = $0
        sub(/^[^[:space:]]+[[:space:]]+[[:xdigit:]]+[[:space:]]+/, "", ref)
        gsub(/^\[|\]$|^\(|\)$/, "", ref)
        print $1 ", " ref
      }'
    ]=]
  )
  vim.ui.select(worktrees, { prompt = "Worktree data:" }, function(worktree)
    if worktree and worktree ~= "" then
      path, branch = unpack(vim.split(worktree, ", "))
      vim.cmd("Git worktree remove " .. path)
      if not utils.starts_with(branch, "detached") then
        vim.cmd("Git branch -D " .. branch)
      end
      print("Worktree removed at " .. path .. " for branch " .. branch)
    else
      print("No worktree specified to remove.")
    end
  end)
end

utils.map('n', '<leader>gs', "<cmd>Git status<cr>", { desc = "git status" })
utils.map('n', '<leader>gk', "<cmd>Telescope git_branches<cr>", { desc = "git checkout branches" })
utils.map('n', '<leader>gb', ":Git checkout -b ", { silent = false, desc = "git checkout branch" })
utils.map('n', '<leader>gd', "<cmd>DiffviewOpen<cr>", { desc = "Open git diff view" })
utils.map('n', '<leader>gD', "<cmd>DiffviewClose<cr>", { desc = "Close git diff view" })
utils.map('n', '<leader>ga', ":Git add ", { silent = false, desc = "git add provided files" })
utils.map('n', '<leader>gt', "<cmd>Git add -u<cr>", { desc = "git add tracked files" })
utils.map('n', '<leader>gA', "<cmd>Git add --all<cr>", { desc = "git add all files" })
utils.map('n', '<leader>gc', "<cmd>Git commit<cr>", { desc = "git commit" })
utils.map('n', '<leader>gu', "<cmd>Git pull<cr>", { desc = "git pull" })
utils.map('n', '<leader>gp', "<cmd>Git push<cr>", { desc = "git push" })
utils.map('n', '<leader>gw', add_worktree, { desc = "git worktree add" })
utils.map('n', '<leader>gW', remove_worktree, { desc = "git worktree remove" })
