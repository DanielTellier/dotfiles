local M = {}

local function obsession_session_name()
    if vim.g.this_session then
        local session_filename = vim.fn.fnamemodify(vim.g.this_session, ':t')
        return vim.split(session_filename, '%.')[1]
    else
        return "UnDef"
    end
end

function M.statusline()
    return "%02n:%<%f %h%m%r[Session(" .. obsession_session_name() .. ")] %=%-14.(%l,%c%V%) %P"
end

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

function M.surround_mappings(map_type)
    local chars = { '`', "'", '"', '[', ']', '{', '}', '(', ')', '<', '>', 't' }
    for _, char in ipairs(chars) do
        if map_type == "word" then
            vim.api.nvim_set_keymap('n', '<leader>w' .. char, 'ysiw' .. char, { noremap = false })
        elseif map_type == "line" then
            vim.api.nvim_set_keymap('n', '<leader>l' .. char, 'yss' .. char, { noremap = false })
        elseif map_type == "change" then
            for _, curr_char in ipairs(chars) do
                if curr_char == char then
                    goto continue
                end
                vim.api.nvim_set_keymap('n', '<leader>' .. curr_char .. char, 'cs' .. curr_char .. char, { noremap = false })
                ::continue::
            end
        elseif map_type == "delete" then
            vim.api.nvim_set_keymap('n', '<leader>d' .. char, 'ds' .. char, { noremap = false })
        elseif map_type == "visual" then
            vim.api.nvim_set_keymap('v', '<leader>' .. char, 'S' .. char, { noremap = false })
        end
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

function M.remove_all_global_marks()
    vim.cmd("delm! | delm A-Z0-9 | echo 'All marks deleted'")
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

-- Utility functions to set key mappings
function M.map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.mapfunc(mode, lhs, func, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, func, options)
end

function M.mapbuf(mode, lhs, rhs, opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local options = { noremap = true, silent = true }
    if opts then
        -- 'force': use value from the rightmost map
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

function M.path_exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat ~= nil
end

function M.has_words_before()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

return M
