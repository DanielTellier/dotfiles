-- Check if the current compiler is already set
if vim.g.current_compiler then
  return
end

-- Set the current compiler to Python
vim.g.current_compiler = "python"

-- Save the current value of 'cpo'
local cpo_save = vim.o.cpo

-- Set 'cpo' to its default value
vim.o.cpo = "C"

-- Set the makeprg to python
vim.bo.makeprg = "python"

-- Set the errorformat to handle Python tracebacks
vim.bo.errorformat = [[
  \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
  \%C\ \ \ \ %.%#,
  \%+Z%.%#Error\:\ %.%#,
  \%A\ \ File\ \"%f\"\\\,\ line\ %l,
  \%+C\ \ %.%#,
  \%-C%p^,
  \%Z%m,
  \%-G%.%#
]]

-- Restore the original value of 'cpo'
vim.o.cpo = cpo_save

