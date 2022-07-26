local function mkSession()
  vim.cmd("!ls $MKS")
  local fname = vim.fn.input("Mk File: ")
  local fpath = vim.env.MYS .. fname .. '.vim'
  vim.cmd("mksession! " .. fpath)
end

local function srcSession()
  vim.cmd("!ls $MKS")
  local fname = vim.fn.input("Mk File: ")
  local fpath = vim.env.MYS .. fname .. '.vim'
  vim.cmd("so " .. fpath)
end

return {
  mkSession = mkSession,
  srcSession = srcSession
}
