-- Finds c/cpp/cu function definitions
local function findCDef(funcName)
  vim.cmd(string.format(
          'exe "silent grep! -wr --include=*.c --include=*.cc ' ..
          '--include=*.cpp --include=*.cu %s ." | redraw!', funcName))

  local matchqfLst = {}
  local qfLst = vim.fn.getqflist()
  for _, qfi in ipairs(qfLst) do
    local fpath = vim.fn.bufname(qfi['bufnr'])
    local _ = vim.fn.bufload(fpath)

    local lastLine = vim.fn.getbufline(fpath, '$')[1]
    local lineNum = qfi['lnum']
    local lineStr = vim.fn.getbufline(fpath, lineNum)[1]
    local matches = vim.fn.match(lineStr, '[/{;]')
    while matches == -1 do
      if lastLine == lineStr then
        break
      end

      lineNum = lineNum + 1
      lineStr = vim.fn.getbufline(fpath, lineNum)[1]
      matches = vim.fn.match(lineStr, '[/{;]')
    end

    if vim.fn.match(lineStr, '{') ~= -1 then
      table.insert(matchqfLst, qfi)
    end
  end

  if vim.fn.len(matchqfLst) > 0 then
    local qfi = matchqfLst[1]
    local fpath = vim.fn.bufname(qfi['bufnr'])
    if vim.fn.len(matchqfLst) == 1 then
      vim.fn.setqflist({}, 'r')
    else
      vim.fn.setqflist(matchqfLst, 'r')
    end
    vim.cmd(string.format('exe "new +%d %s"', qfi['lnum'], fpath))
    vim.cmd(string.format('echo "File Found at %d"', qfi['lnum']))
  else
    vim.cmd('echo "File Not Found"')
  end
end

-- Adds extra functionality to grep command
local function grepExt(pattern, ext, dir)
  local fincs = ''
  if ext == 'cc' then
    fincs = '--include="*.c" --include="*.cpp" --include="*.cu"'
  elseif ext == 'hh' then
    fincs = '--include="*.h" --include="*.hpp" --include="*.cuh"'
  elseif ext == 'mk' then
    fincs = '--include="Makefile" --include="makefile" --include="*.mk"'
  else
    fincs = '--include="*.c" --include="*.cpp" --include="*.cu" ' ..
            '--include="*.h" --include=*.hpp --include=*.cuh ' ..
            '--include="Makefile" --include="makefile" --include="*.mk"'
  end

  vim.cmd("exe silent! grep! -rw " .. fincs .. " " .. pattern ..
          " " .. dir .. " | cw | redraw!")
end

return {
  findCDef = findCDef,
  grepExt = grepExt
}
