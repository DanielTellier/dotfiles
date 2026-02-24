local M = {}

if vim.g.autoloaded_search then
  return M
end

vim.g.autoloaded_search = 1

local function run_grep(exts, pattern, gtype)
  local l_exts = vim.split(exts, ",")
  local cmd = ''
  local fincs = ''

  if exts == 'all' then
    fincs = ' --include=*'
  else
    for _, e in ipairs(l_exts) do
      fincs = fincs .. ' --include="*.' .. e .. '"'
    end
  end
  cmd = 'silent! grep! -r'
  if gtype == 'exact' then
    cmd = cmd .. ' -w'
  else
    cmd = cmd .. ' -i'
  end
  cmd = cmd .. fincs .. ' ' .. pattern .. ' .'
  vim.cmd(cmd)
  print("Ran " .. cmd)
end

function M.search_grep(exts, pattern)
  run_grep(exts, pattern, 'nonexact')
  vim.cmd('cw | redraw!')
end

local function check_qflist(qflist)
  if #qflist > 0 then
    local qfi = qflist[1]
    local fpath = vim.fn.bufname(qfi.bufnr)
    if #qflist == 1 then
      vim.fn.setqflist({}, 'r')
    else
      vim.fn.setqflist(qflist, 'r')
    end
    vim.cmd('sp +' .. qfi.lnum .. ' ' .. fpath)
    vim.cmd('echo "File Found at "' .. qfi.lnum)
  else
    vim.cmd('echo "File Not Found"')
  end
end

function M.search_cdef(funcName)
  run_grep('c,cc,cpp,cu', funcName, 'exact')

  local newqfLst = {}
  local qfLst = vim.fn.getqflist()
  for _, qfi in ipairs(qfLst) do
    local fpath = vim.fn.bufname(qfi.bufnr)
    local isLoaded = vim.fn.bufloaded(fpath)
    if isLoaded == 0 then
      vim.cmd('tabnew ' .. fpath)
    end
    local lineEOF = vim.fn.getbufline(fpath, '$')[1]
    local lineNum = qfi.lnum
    local lineStr = vim.fn.getbufline(fpath, lineNum)[1]
    local matches = string.find(lineStr, '[/{;]')
    while not matches do
      if lineEOF == lineStr then break end
      lineNum = lineNum + 1
      lineStr = vim.fn.getbufline(fpath, lineNum)[1]
      matches = string.find(lineStr, '[/{;]')
    end

    if isLoaded == 0 then
      vim.cmd('bdelete ' .. fpath)
    end

    if string.find(lineStr, '{') then
      table.insert(newqfLst, qfi)
    end
  end

  check_qflist(newqfLst)
end

function M.search_pydef(funcName, def_type)
  run_grep('py', funcName, 'exact')

  local newqfLst = {}
  local qfLst = vim.fn.getqflist()
  for _, qfi in ipairs(qfLst) do
    local fpath = vim.fn.bufname(qfi.bufnr)
    local isLoaded = vim.fn.bufloaded(fpath)
    if isLoaded == 0 then
      vim.cmd('tabnew ' .. fpath)
    end

    local lineEOF = vim.fn.getbufline(fpath, '$')[1]
    local lineNum = qfi.lnum
    local lineStr = vim.fn.getbufline(fpath, lineNum)[1]
    if isLoaded == 0 then
      vim.cmd('bdelete ' .. fpath)
    end

    if string.find(lineStr, def_type) then
      table.insert(newqfLst, qfi)
    end
  end

  check_qflist(newqfLst)
end

return M
