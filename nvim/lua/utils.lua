local M = {}

-- Toggle
function M.toggle_all()
  if vim.wo.number or vim.wo.relativenumber or vim.wo.list then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.list = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.list = true
  end
end

function M.toggle_highlights()
  if vim.o.hlsearch then
    vim.o.hlsearch = false
  else
    vim.o.hlsearch = true
  end
end

function M.toggle_numbers()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
  elseif vim.wo.number then
    vim.wo.number = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end


-- Files
function M.open_path(path)
  local tabcurr = vim.fn.tabpagenr()
  local tablast = vim.fn.tabpagenr('$')
  if vim.fn.isdirectory(path) == 1 then
    for i = 1, tablast do
      if vim.bo.filetype == "netrw" or vim.bo.filetype == "multi-tree" then
        vim.cmd('edit ' .. path)
        return
      end
      vim.cmd(i .. 'tabnext')
    end
    vim.cmd(tabcurr .. 'tabnext')
  end

  if vim.fn.bufname('%') == '' then
    vim.cmd('edit ' .. path)
  else
    vim.cmd('tabnew ' .. path)
  end
end

function M.open_after_ft()
  local after_file = rtp .. "/after/ftplugin/" .. vim.bo.filetype .. ".vim"
  if vim.fn.filereadable(after_file) == 1 then
    vim.cmd('tabnew ' .. after_file)
  else
    print("File does not exist: " .. after_file)
  end
end

function M.path_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat ~= nil
end


-- Netrw
function M.split_netrw(bufcmd, is_stay)
  vim.cmd('normal v')
  local bufname = vim.fn.bufname('%')
  vim.cmd('close!')
  local tabnext = vim.fn.tabpagenr() + 1
  local tablast = vim.fn.tabpagenr('$')
  if tabnext > tablast then
    vim.cmd('tabnew')
    bufcmd = 'edit'
  else
    vim.cmd(tabnext .. 'tabnext')
  end
  vim.cmd(bufcmd .. ' ' .. bufname)
  if is_stay then
    vim.cmd(vim.fn.tabpagenr('#') .. 'tabnext')
  end
end


-- Buffers
function M.delete_all_buffers()
  local current_pos = vim.fn.getpos('.')
  vim.cmd("%bd | e# | echo 'Buffers deleted'")
  vim.fn.setpos('.', current_pos)
end

local function switch_to_buffer_if_open(desired_buf)
  local current_buf = vim.api.nvim_get_current_buf()
  local win_list = vim.api.nvim_list_wins()
  local found_open_window = false
  if current_buf == desired_buf then
    print("Already in desired buffer: " .. desired_buf)
    return true
  end
  for _, win in ipairs(win_list) do
    if vim.api.nvim_win_get_buf(win) == desired_buf then
      vim.api.nvim_set_current_win(win)
      vim.api.nvim_set_current_buf(desired_buf)
      found_open_window = true
      break
    end
  end

  return found_open_window
end


-- Terminal
-- Function to paste yanked text into the terminal
function M.paste_to_terminal()
  -- Get the yanked text from the unnamed register
  local yanked_text = vim.fn.getreg('"')
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype == 'terminal' then
    vim.api.nvim_paste(yanked_text, true, -1)
  else
    print("Not in a terminal buffer")
  end
end

-- Function to toggle the last open terminal buffer
-- NOTE:
-- vim.g.last_buffer and vim.g.last_term are set in augroup terminal-group
-- in the file lua/commands.lua
function M.toggle_terminal()
  local buffers = vim.api.nvim_list_bufs()
  local last_terminal_buf = nil

  -- Find the last terminal buffer
  for _, buf in ipairs(buffers) do
    if (
      vim.api.nvim_buf_is_loaded(buf) and
      vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal'
    ) then
      last_terminal_buf = buf
    end
  end

  if last_terminal_buf then
    local current_buf = vim.api.nvim_get_current_buf()
    local alternate_buf = vim.fn.bufnr('#')
    local win_list = vim.api.nvim_list_wins()
    local found_open_window = false

    if (
      current_buf == last_terminal_buf or
      vim.api.nvim_buf_get_option(current_buf, 'buftype') == 'terminal'
    ) then
      if vim.g.last_buffer then
        alternate_buf = vim.g.last_buffer
      end
      found_open_window = switch_to_buffer_if_open(alternate_buf)
      if not found_open_window then
        -- Switch to the alternate buffer if not open in any window
        vim.cmd('split | buffer #')
      end
    else
      if vim.g.last_term then
        last_terminal_buf = vim.g.last_term
      end
      found_open_window = switch_to_buffer_if_open(last_terminal_buf)
      if not found_open_window then
        -- Open the terminal buffer in a new window
        vim.cmd('split | buffer ' .. last_terminal_buf)
      end
    end
  else
    print("No terminal buffer found.")
  end
end


-- Key Mappings
-- Utility functions to set key mappings
function M.map(modes, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(modes, lhs, rhs, options)
end

function M.mapbuf(modes, lhs, rhs, opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local options = { noremap = true, silent = true }
  if opts then
    -- 'force': use value from the rightmost map
    options = vim.tbl_extend('force', options, opts)
  end
  if type(modes) == "string" then
    modes = { modes }  -- Convert to table if a single mode is provided
  end
  for _, mode in ipairs(modes) do
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
  end
end


-- Misc
function M.has_words_before()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

function M.table_concat(table1, table2)
  for i = 1, #table2 do
    table1[#table1 + 1] = table2[i]
  end
end

function M.delete_all_global_marks()
  vim.cmd("delmarks! | delmarks A-Z0-9 | echo 'All marks deleted'")
end

function M.delete_duplicate_quickfix_entries()
  local seen = {}
  local qflist = {}
  for _, item in ipairs(vim.fn.getqflist()) do
    local key = item.bufnr .. ':' .. item.lnum .. ':' .. item.col
    if not seen[key] then
      table.insert(qflist, item)
      seen[key] = true
    end
  end
  vim.fn.setqflist(qflist, 'r')
end

function M.get_files_from_path(path)
  local files = {}
  local dir_iterator = vim.fs.dir(path)
  if not dir_iterator then
    vim.notify("Error: Could not read directory: " .. path, vim.log.levels.ERROR)
  else
    for filename, entry_type in dir_iterator do
      if entry_type == "file" then
        -- local filename_without_ext = vim.fn.fnamemodify(filename_with_ext, ":r")
        table.insert(files, filename)
      end
    end
  end

  return files
end

function M.augroup(name, opts)
  opts = opts or { clear = true }
  return vim.api.nvim_create_augroup("nvim_ide_" .. name, opts)
end

--- Moves the current buffer to another tab page.
-- Can move to the next/previous tab, or a specific tab number.
--
-- @param opts (table) A table of options:
--   - tab_number (number, optional): The specific tab number to move to (e.g., 1, 2, 3).
--                                    This option takes precedence over 'direction'.
--   - direction (string, optional): 'next' or 'prev'. Used if 'tab_number' is not provided.
--                                   Defaults to 'next'.
--   - split (string, optional): 'horizontal' or 'vertical'. Defaults to 'horizontal'.
function M.move_to_tab(opts)
  opts = opts or {}
  local split_type = opts.split or 'horizontal'

  -- 1. Guard against moving special buffers
  if vim.bo.buftype ~= '' then
    vim.notify('Cannot move special buffers.', vim.log.levels.WARN)
    return
  end

  -- 2. Get current state
  local current_buf = vim.api.nvim_get_current_buf()
  local original_win = vim.api.nvim_get_current_win()
  local current_tab_num = vim.fn.tabpagenr()
  local tab_count = vim.fn.tabpagenr('$')

  -- 3. Determine the target tab number
  local target_tab_num
  if opts.tab_number then
    -- Prioritize moving to a specific tab number
    if type(opts.tab_number) == 'number' and opts.tab_number > 0 then
      target_tab_num = opts.tab_number
    else
      vim.notify('Invalid tab_number provided. Must be a positive number.', vim.log.levels.ERROR)
      return
    end
  else
    -- Fallback to 'next' or 'prev' direction
    local direction = opts.direction or 'next'
    local offset = (direction == 'prev') and -1 or 1
    target_tab_num = current_tab_num + offset
  end

  -- Prevent moving a buffer to its own tab if it's the only window
  if target_tab_num == current_tab_num and #vim.api.nvim_tabpage_list_wins(0) == 1 then
    vim.notify('Cannot move buffer to the same tab.', vim.log.levels.INFO)
    return
  end

  -- 4. Determine the split command modifier
  local split_modifier = (split_type == 'vertical') and 'vert' or ''

  -- 5. Execute the move
  -- Case 1: The target tab exists
  if target_tab_num > 0 and target_tab_num <= tab_count then
    vim.cmd(string.format('%dtabnext | %s sbuffer %d', target_tab_num, split_modifier, current_buf))
  else
    -- Case 2: The target tab does not exist, create a new one
    vim.cmd('tabnew')
    vim.api.nvim_set_current_buf(current_buf)
  end

  -- 6. Clean up the original window from our new location.
  vim.api.nvim_win_close(original_win, false)
end

-- Example of dev_paths.json content:
-- {
--   "paths": [
--     {
--       "name": "Dotfiles",
--       "path": "/Users/user/.dotfiles"
--     },
--     {
--       "name": "Projects",
--       "path": "/Users/user/Projects"
--     }
--   ]
-- }
function M.select_dev_path_and_find_files()
  local config_file = vim.fn.stdpath('data') .. '/dev_paths.json'

  -- Read and parse JSON
  local file = io.open(config_file, 'r')
  if not file then
    vim.notify(
      'Create ' .. config_file .. ': {"paths": [{"name": "Project", "path": "/path"}]}',
      vim.log.levels.ERROR
    )
    return
  end

  local ok, data = pcall(vim.json.decode, file:read('*all'))
  file:close()

  if not ok or not data.paths then
    vim.notify("Invalid JSON in " .. config_file, vim.log.levels.ERROR)
    return
  end

  -- Create picker
  require('telescope.pickers').new({}, {
    prompt_title = "Select Development Path",
    finder = require('telescope.finders').new_table({
      results = data.paths,
      entry_maker = function(entry)
        return {
          value = entry.path,
          display = entry.name .. " (" .. entry.path .. ")",
          ordinal = entry.name,
        }
      end,
    }),
    sorter = require('telescope.config').values.generic_sorter({}),
    attach_mappings = function(bufnr)
      require('telescope.actions').select_default:replace(function()
        require('telescope.actions').close(bufnr)
        local path = require('telescope.actions.state').get_selected_entry().value
        require('telescope.builtin').find_files({ cwd = path })
      end)
      return true
    end,
  }):find()
end

-- Add all files under a directory to the buffer list (no opening).
function M.buf_add_dir(file_pattern, dir)
  file_pattern = file_pattern or '*'
  dir = vim.fn.fnamemodify(dir, ':p')
  dir = dir:gsub("/+$", "") -- strip trailing slashes
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify('Not a directory: ' .. dir, vim.log.levels.ERROR)
    return
  end
  for _, path in ipairs(vim.fn.glob(dir .. '/**/' .. file_pattern, false, true)) do
    if vim.fn.filereadable(path) == 1 then
      local current_win = vim.api.nvim_get_current_win()
      vim.cmd('tabnew ' .. path)
      vim.cmd('tabclose')
      vim.api.nvim_set_current_win(current_win)
    end
  end
end

--[[
Transform indentation in a list of lines from one spacing to another.

This function intelligently handles mixed indentation by tracking scope changes and only
converting lines that use the old indentation system. It detects when a line increases
indentation by exactly `from_spaces` and marks that indentation level for conversion.

@param lines table: Array of strings representing file lines
@param from_spaces number: Source indentation size (e.g., 4 for 4-space indentation)
@param to_spaces number: Target indentation size (e.g., 2 for 2-space indentation)
@return boolean: True if any lines were modified, false otherwise

Cases This Function Handles:
1. Basic mixed indentation conversion: Lines using 4-space indents get converted to 2-space while preserving existing 2-space lines
2. Same-level siblings: All lines at a marked indentation level get converted consistently
3. Proper dedentation cleanup: When exiting nested blocks, deeper marked indents get cleared
4. Scope resets: All markings reset when returning to column 0
5. Nested blocks: Correctly handles multiple levels of nesting with mixed indentation

Cases This Function Cannot Handle:
1. Files with mixed source indentation sizes: Only converts one source indentation size per call
2. Tab characters: Only handles spaces, ignores tab characters
3. Files without column 0 resets: Markings persist incorrectly across unrelated code sections
4. Non-standard jump sizes: Only detects exact from_spaces increases, misses other increment patterns
5. Inconsistent spacing within scopes: Cannot handle mixed 4/6-space indents that should both be converted

The function works best for files with a single old indentation system (4-space) being converted to a new system (2-space), with proper scope boundaries.

Example:
  if True:        -- 2 spaces (unchanged)
   return "x"  -- 4 spaces (converted to 4 spaces for proper nesting)
--]]
local function transform_lines_indent(lines, from_spaces, to_spaces)
  local changed = false
  local prev_indent = 0
  local marked_indents = {}

  for i, line in ipairs(lines) do
    local indent = line:match("^( *)")
    local indent_size = #indent

    if indent_size > 0 then
      -- Clear deeper indents when we dedent
      if indent_size < prev_indent then
        for indent, _ in pairs(marked_indents) do
          if indent > indent_size then
            marked_indents[indent] = nil
          end
        end
      end

      local indent_diff = indent_size - prev_indent

      -- Mark indent for conversion if it increases by exactly from_spaces
      if indent_diff == from_spaces then
        marked_indents[indent_size] = true
      end

      -- Convert if this indent was marked for conversion
      if marked_indents[indent_size] then
        local level = indent_size / from_spaces
        local new_indent = level * to_spaces

        if new_indent ~= indent_size then
          lines[i] = string.rep(" ", new_indent) .. line:sub(indent_size + 1)
          changed = true
        end
      end

      prev_indent = indent_size
    else
      prev_indent = 0
      marked_indents = {}  -- Reset all when we hit column 0
    end
  end
  return changed
end

-- Apply indent transformation to current buffer
function M.transform_indent_buffer(from_spaces, to_spaces)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  transform_lines_indent(lines, from_spaces, to_spaces)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.notify(("Transformed current buffer: %d-space → %d-space indents"):format(from_spaces, to_spaces))
end

-- Apply indent transformation to files recursively
function M.transform_indent_files(directory, file_pattern, from_spaces, to_spaces)
  local files = vim.fn.glob(directory .. "/**/" .. file_pattern, false, true)

  if #files == 0 then
    vim.notify("No files found matching pattern: " .. file_pattern .. " in " .. directory, vim.log.levels.WARN)
    return
  end

  local count = 0
  for _, file in ipairs(files) do
    if vim.fn.isdirectory(file) == 0 then
      local lines = vim.fn.readfile(file)
      if transform_lines_indent(lines, from_spaces, to_spaces) then
        vim.fn.writefile(lines, file)
        count = count + 1
      end
    end
  end

  vim.notify(("Transformed %d files: %d-space → %d-space indents"):format(count, from_spaces, to_spaces))
end

return M
