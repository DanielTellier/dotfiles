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
function M.change_file_indent_size(curr_size, new_size)
    local curr_file = vim.fn.bufname('%')
    local tmp_file = '/tmp/set_vim_file_indent.txt'
    local curr_set = 'set tabstop=' .. curr_size .. ' softtabstop=' .. curr_size
    local new_set = 'set tabstop=' .. new_size .. ' softtabstop=' .. new_size
    vim.cmd('!cp ' .. curr_file .. ' ' .. tmp_file)
    vim.cmd('edit ' .. tmp_file)
    vim.cmd(curr_set .. ' noexpandtab | retab! | write')
    vim.cmd('!cat ' .. tmp_file .. ' > ' .. curr_file)
    vim.cmd('edit ' .. curr_file)
    vim.cmd(new_set .. ' expandtab | retab | write')
    vim.cmd('!rm ' .. tmp_file)
end

function M.open_path(path)
    local tabcurr = vim.fn.tabpagenr()
    local tablast = vim.fn.tabpagenr('$')
    if vim.fn.isdirectory(path) == 1 then
        for i = 1, tablast do
            if vim.bo.filetype == "netrw" then
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


-- Surround
function M.surround_mappings(map_type)
    local chars = { '`', "'", '"', '[', ']', '{', '}', '(', ')', '<', '>', 't' }
    for _, char in ipairs(chars) do
        if map_type == "word" then
            vim.api.nvim_set_keymap(
                'n', '<leader>uw' .. char, 'ysiw' .. char,
                { noremap = false, desc = 'Surround word with ' .. char }
            )
        elseif map_type == "line" then
            vim.api.nvim_set_keymap(
                'n', '<leader>ul' .. char, 'yss' .. char,
                { noremap = false, desc = 'Surround line with ' .. char }
            )
        elseif map_type == "change" then
            for _, curr_char in ipairs(chars) do
                if curr_char == char then
                    goto continue
                end
                vim.api.nvim_set_keymap(
                    'n', '<leader>u' .. curr_char .. char, 'cs' .. curr_char .. char,
                    { noremap = false, desc = 'Change ' .. curr_char .. ' to ' .. char }
                )
                ::continue::
            end
        elseif map_type == "delete" then
            vim.api.nvim_set_keymap(
                'n', '<leader>ud' .. char, 'ds' .. char,
                { noremap = false, desc = 'Delete ' .. char }
            )
        elseif map_type == "visual" then
            vim.api.nvim_set_keymap(
                'v', '<leader>u' .. char, 'S' .. char,
                { noremap = false, desc = 'Visual Surround with ' .. char }
            )
        end
    end
end


-- Buffers
function M.search_buffers_(pattern)
    local bufferlist = vim.fn.execute('ls')
    for _, line in ipairs(vim.split(bufferlist, '\n')) do
        if line:match(pattern) then
            print(line)
        end
    end
end

function M.remove_all_buffers()
    local current_pos = vim.fn.getpos('.')
    vim.cmd("%bd | e# | echo 'Buffers Removed'")
    vim.fn.setpos('.', current_pos)
end

function M.remove_matching_buffers(pattern)
    local bufferList = vim.tbl_filter(function(val) return vim.fn.buflisted(val) == 1 end, vim.fn.range(1, vim.fn.bufnr('$')))
    local matchingBuffers = vim.tbl_filter(function(val) return vim.fn.bufname(val):match(pattern) end, bufferList)
    if #matchingBuffers < 1 then
        print('No buffers found matching pattern ' .. pattern)
        return
    end
    vim.cmd('bd ' .. table.concat(matchingBuffers, ' '))
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

function M.open_cwd_in_tab1()
    vim.cmd('tabnew . | tabmove 0')
end

function M.remove_all_global_marks()
    vim.cmd("delmarks! | delmarks A-Z0-9 | echo 'All marks deleted'")
end

function M.remove_duplicate_quickfix_entries()
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

return M
