local utils = require('utils')
local rtp = vim.split(vim.o.runtimepath, ",")[1]
local home = os.getenv('HOME')

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Navigation
utils.map(
    'n', 'n', 'nzzzv',
    { silent = false, desc = "Keep it centered when searching for next" }
)
utils.map(
    'n', 'N', 'Nzzzv',
    { silent = false, desc = "Keep it centered when searching for previous" }
)
utils.map(
    'n', 'J', 'mzJ`z',
    { silent = false, desc = "Join lines and keep cursor position" }
)
utils.map(
    'n', '<c-d>', '<c-d>zz',
    { silent = false, desc = "Go down half a page and center." }
)
utils.map(
    'n', '<c-u>', '<c-u>zz',
    { silent = false, desc = "Go up half a page and center." }
)
utils.map(
    'n', '<c-f>', '<c-f>zz',
    { silent = false, desc = "Go down a page and center." }
)
utils.map(
    'n', '<c-b>', '<c-b>zz',
    { silent = false, desc = "Go up a page and center." }
)
utils.map(
    "n", "<leader>oo", "o<esc>o<esc>o<esc>k",
    { desc = "Create a new line with 2 spaces around it" }
)
-- Referenced from here: https://github.com/jiangmiao/auto-pairs/blob/master/plugin/auto-pairs.vim#L576
-- <buffer> (utils.mapbuf in my case) is not working for neovim so cannot do:
-- vim.g.AutoPairsShortcutJump = "<c-p>"
utils.map(
    'n', '<c-p>', [=[<esc>:call search('["\]'')}]','W')<cr>a]=],
    { desc = "Move cursor in front of closing pair symbol" }
)
utils.map(
    'i', '<c-p>', [=[<esc>:call search('["\]'')}]','W')<cr>a]=],
    { desc = "Move cursor in front of closing pair symbol in insert mode" }
)
utils.map('n', 'Y', 'y$', { silent = false, desc = "Yank to end of line" })
-- Force use of hjkl-style movement and up(c-b)/down(c-f)
local keys_to_nop = {
    '<up>', '<down>', '<left>', '<right>', '<pageup>', '<pagedown>', '<home>', '<end>'
}
for _, key in ipairs(keys_to_nop) do
    utils.map('', key, '<nop>', { noremap = false, silent = false })
    utils.map('i', key, '<nop>', { noremap = false, silent = false })
end
-- Remap these keys to work with hjkl-style movement
utils.map('', '$', '<nop>', { noremap = false, silent = false })
utils.map('', '^', '<nop>', { noremap = false, silent = false })
utils.map('', '{', '<nop>', { noremap = false, silent = false })
utils.map('', '}', '<nop>', { noremap = false, silent = false })
utils.map('', 'K', '{', { silent = false, desc = "Move up a paragraph" })
utils.map('', 'J', '}', { silent = false, desc = "Move down a paragraph" })
utils.map('', 'H', '^', { silent = false, desc = "Move to start of line" })
utils.map('', 'L', '$', { silent = false, desc = "Move to end of line" })

-- Open File
utils.mapfunc('n', '<leader>ed', function()
    utils.open_path(rtp .. '/doc/common-maps.txt')
end, { desc = "Open docs that contain key mappings" })
utils.mapfunc('n', '<leader>ev', function()
    utils.open_path(rtp .. '/init.lua')
end, { desc = "Open init.lua" })
utils.mapfunc('n', '<leader>ek', function()
    utils.open_path(rtp .. '/lua/mappings.lua')
end, { desc = "Open mappings.lua" })
utils.mapfunc('n', '<leader>ea', function()
    utils.open_after_ft()
end, { desc = "Open custom after file type if exists" })
utils.mapfunc('n', '<leader>eb', function()
    utils.open_path(home .. '/.bashrc')
end, { desc = "Open bashrc" })

-- Toggle
utils.mapfunc('n', '<leader>th', function()
    utils.toggle_highlights()
end, { desc = "Toggle highlights" })
utils.map(
    'n', '/', ':set hlsearch<cr>/',
    { silent = false, desc = "Ensure highlighting is on when searching" }
)
utils.mapfunc('n', '<leader>tn', function()
    utils.toggle_numbers()
end, { desc = "Toggle numbers" })
utils.map(
    'n', '<leader>tl', ':if (&list) | set nolist | else | set list | endif<cr>',
    { desc = "Toggle listchars" }
)
utils.mapfunc('n', '<leader>ta', function()
    utils.toggle_all()
end, { desc = "Toggle listchars and numbers" })

-- Substitution
for _, mode in ipairs({'n', 'v'}) do
    utils.map(
        mode, '<leader>swg', ':%s/<c-r><c-w>//g' .. string.rep('<left>', 2),
        { silent = false, desc = "Global substitution with word under cursor" }
    )
    utils.map(
        mode, '<leader>swc', ':%s/<c-r><c-w>//gc' .. string.rep('<left>', 3),
        {
            silent = false,
            desc = "Global substitution with word under cursor and confirmation",
        }
    )
    utils.map(
        mode, '<leader>sbg', ':%s/\\(<c-r><c-w>\\)/\\1/g' .. string.rep('<left>', 4),
        { silent = false, desc = "Global prefix with word under cursor" }
    )
    utils.map(
        mode, '<leader>sbc', ':%s/\\(<c-r><c-w>\\)/\\1/gc' .. string.rep('<left>', 5),
        {
            silent = false,
            desc = "Global prefix with word under cursor and confirmation",
        }
    )
    utils.map(
        mode, '<leader>sag', ':%s/\\(<c-r><c-w>\\)/\\1/g' .. string.rep('<left>', 3),
        { silent = false, desc = "Global postfix with word under cursor" }
    )
    utils.map(
        mode, '<leader>sac', ':%s/\\(<c-r><c-w>\\)/\\1/gc' .. string.rep('<left>', 4),
        {
            silent = false,
            desc = "Global postfix with word under cursor and confirmation",
        }
    )
    utils.map(
        mode, '<leader>sbr',
        ':bufdo %s/<c-r><c-w>//g | update' .. string.rep('<left>', 11),
        {
            silent = false,
            desc = "Global substitution across buffers with word under cursor",
        }
    )
    -- Can add files to arg list via `:args *.txt` or `:args file1.txt file2.txt ...`
    utils.map(
        mode, '<leader>sar',
        ':argdo %s/<c-r><c-w>//g | update' .. string.rep('<left>', 11),
        {
            silent = false,
            desc = "Global substitution across file in argument " ..
            "list with word under cursor",
        }
    )
end

-- Search
utils.map(
    'n', '<leader>cl', ':s///gn' .. string.rep('<left>', 4),
    { silent = false, desc = "Count instances in the current line" }
)
utils.map(
    'n', '<leader>cg', ':%s///gn' .. string.rep('<left>', 4),
    { silent = false, desc = "Count instances globally" }
)
utils.map(
    'n', '<leader>ws', ':Mgrep all "\\b<c-r><c-w>\\b"<cr>:cw<cr>',
    { desc = "Search word under cursor recursively under current directory" }
)
utils.map(
    'n', '<leader>is', ':Mgrep all ',
    { desc = "Search word given user input recursively under current directory" }
)
utils.map(
    'n', '<leader>em', '/\\<<c-r><c-w>\\>',
    { silent = false, desc = "Search exact match in current buffer" }
)
utils.map('n', '<leader>co', ':copen<cr>', { desc = "Open quickfix list" })
utils.map('n', '<leader>cq', ':cclose<cr>', { desc = "Close quickfix list" })

-- Git
utils.map(
    "n", "<leader>do", "<cmd>DiffviewOpen<cr>", { desc = "Open git diff view plugin" }
)
utils.map(
    "n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "Close git diff view plugin"}
)

-- Terminal
utils.map('n', '<leader>me', ':terminal<cr>', { desc = "Open terminal" })
utils.map(
    'n', '<leader>mv', ':vertical terminal<cr>', { desc = "Open vertical terminal" }
)
utils.map(
    'n', '<leader>mo', ':split | terminal<cr>', { desc = "Open horizontal terminal" }
)
utils.map(
    'n', '<leader>mt', ':tab terminal<cr>', { desc = "Open terminal in new tab" }
)
utils.mapfunc('n', '<leader>tt', function()
    utils.toggle_terminal()
end, { desc = "Toggle the last terminal buffer" })
utils.map('t', '<esc>', '<c-\\><c-n>', { silent = false, desc = "Exit terminal mode" })
utils.map('t', '<c-h>', '<c-w><c-h>', { silent = false, desc = "Move to left window" })
utils.map('t', '<c-j>', '<c-w><c-j>', { silent = false, desc = "Move to bottom window" })
utils.map('t', '<c-k>', '<c-w><c-k>', { silent = false, desc = "Move to top window" })
utils.map('t', '<c-l>', '<c-w><c-l>', { silent = false, desc = "Move to right window" })
utils.mapfunc('t', '<c-w>p', function()
    utils.paste_to_terminal()
end, { desc = "Paste yanked text into terminal" })
utils.map('n', '<leader>mq', '<cmd>q!<cr>', { desc = "Exit terminal" })

-- Surround
utils.surround_mappings("word")
utils.surround_mappings("line")
utils.surround_mappings("change")
utils.surround_mappings("delete")
utils.surround_mappings("visual")

-- Window
utils.map('n', '<c-h>', '<c-w>h', { silent = false, desc = "Move to left window" })
utils.map('n', '<c-j>', '<c-w>j', { silent = false, desc = "Move to bottom window" })
utils.map('n', '<c-k>', '<c-w>k', { silent = false, desc = "Move to top window" })
utils.map('n', '<c-l>', '<c-w>l', { silent = false, desc = "Move to right window" })
utils.map('n', '<leader>wu', '<c-w>R', { desc = "Rotate window upwards or leftwards" })
utils.map(
    'n', '<leader>wd', '<c-w>r', { desc = "Rotate window downwards or rightwords" }
)
utils.map('n', '<leader>wh', '<c-w>H', { desc = "Move window to left" })
utils.map('n', '<leader>wj', '<c-w>J', { desc = "Move window to bottom" })
utils.map('n', '<leader>wk', '<c-w>K', { desc = "Move window to top" })
utils.map('n', '<leader>wl', '<c-w>L', { desc = "Move window to right" })
utils.map('n', '<leader>wt', '<c-w>T', { desc = "Move window to new tab" })
utils.map(
    'n', '<leader>wc', ':exe "tabnew " .. expand("%")<cr>',
    { desc = "Move current window to new tab" }
)
utils.map(
    'n', '<leader>wp', ':exe "vs " .. expand("#")<cr>',
    { desc = "Move previous window to vertical split" }
)
utils.map(
    "n",
    "<c-w>.",
    "<c-w>=z12<cr>",
    { desc = "Sets window size = ideal size for 2 buffers and 2 terms" }
)
utils.map(
    "n",
    "<leader>=",
    "<cmd>vertical resize +5<cr>",
    { desc = "Increase window size vertically" }
)
utils.map(
    "n",
    "<leader>-",
    "<cmd>vertical resize -5<cr>",
    { desc = "Decrease window size vertically" }
)

-- Path Info
utils.map(
    'n', '<leader>fy', ':let @f = expand("%:t")<cr>', { desc = "Yank file name" }
)
utils.map(
    'n', '<leader>Fy', ':let @f = expand("%:p")<cr>', { desc = "Yank full file path" }
)
utils.map('n', '<leader>fp', '"fp', { desc = "Paste file name" })

-- Buffer
utils.map(
    'n', '<leader>bs', ':BuffersSearch ',
    { silent = false, desc = "Search buffers in list defined in commands.lua" }
)
utils.map('n', '<leader>bl', ':buffers<cr>', { silent = false, desc = "List buffers" })
utils.map('n', '<leader>bb', ':buffer ', { silent = false, desc = "Switch buffer" })
utils.map(
    'n', '<leader>bo', ':sbuffer ',
    { silent = false, desc = "Switch buffer in horizontal split" }
)
utils.map(
    'n', '<leader>bv', ':vertical sbuffer ',
    { silent = false, desc = "Switch buffer in vertical split" }
)
utils.map(
    'n', '<leader>rb', ':RemoveWhichBuffer ',
    { silent = false, desc = "Remove buffer from list defined in commands.lua" }
)
utils.mapfunc('n', '<leader>rB', function()
    utils.remove_all_buffers()
end, { silent = false, desc = "Remove all buffers from list" })

-- Mark
utils.map(
    'n', '<leader>rm', ':delmarks ', { silent = false, desc = "Remove mark from list" }
)
utils.mapfunc('n', '<leader>rM', function()
    utils.remove_all_global_marks()
end, { silent = false, desc = "Remove all global marks" })

-- Copilot
if vim.g.copilot_available then
    local ask_copilot = function()
        -- CopilotChat quick chat
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
            require("CopilotChat").ask(
                input, { selection = require("CopilotChat.select").buffer }
            )
        end
    end
    utils.mapfunc('n', '<leader>cci', function()
        ask_copilot()
    end, { silent = false, desc = 'CopilotChat - Ask input' })
    utils.map(
        'n', '<leader>ccD', '<cmd>CopilotChatDebugInfo<cr>',
        { desc = 'CopilotChat - Debug info' }
    )
    utils.map(
        'n', '<leader>cgc', '<cmd>CopilotChatCommit<cr>',
        { desc = 'CopilotChat - Git commit suggestion' }
    )
    utils.map(
        'n', '<leader>ccq', '<cmd>CopilotChatClose<cr>',
        { desc = 'CopilotChat - Close chat window' }
    )
    -- Reference prompts list set in init.lua for the below mappings
    for _, mode in ipairs({'n', 'v'}) do
        utils.map(
            mode, '<leader>cco', '<cmd>CopilotChat<cr>',
            { desc = 'CopilotChat - Open chat window' }
        )
        utils.map(
            mode, '<leader>cce', '<cmd>CopilotChatExplain<cr>',
            { desc = 'CopilotChat - Explain code' }
        )
        utils.map(
            mode, '<leader>cct', '<cmd>CopilotChatTests<cr>',
            { desc = 'CopilotChat - Generate Tests' }
        )
        utils.map(
            mode, '<leader>ccr', '<cmd>CopilotChatReview<cr>',
            { desc = 'CopilotChat - Review code' }
        )
        utils.map(
            mode, '<leader>ccR', '<cmd>CopilotChatRefactor<cr>',
            { desc = 'CopilotChat - Refactor code' }
        )
        utils.map(
            mode, '<leader>ccf', '<cmd>CopilotChatFixCode<cr>',
            { desc = 'CopilotChat - Fix code' }
        )
        utils.map(
            mode, '<leader>ccd', '<cmd>CopilotChatDocumentation<cr>',
            { desc = 'CopilotChat - Add documentation for code' }
        )
        utils.map(
            mode, '<leader>cca', '<cmd>CopilotChatSwaggerApiDocs<cr>',
            { desc = 'CopilotChat - Add Swagger API documentation' }
        )
        utils.map(
            mode, '<leader>ccA', '<cmd>CopilotChatSwaggerNumpyDocs<cr>',
            { desc = 'CopilotChat - Add Swagger API documentation with Numpy Documentation' }
        )
        utils.map(
            mode, '<leader>ccs', '<cmd>CopilotChatSummarize<cr>',
            { desc = 'CopilotChat - Summarize text' }
        )
        utils.map(
            mode, '<leader>ccS', '<cmd>CopilotChatSpelling<cr>',
            { desc = 'CopilotChat - Correct spelling' }
        )
        utils.map(
            mode, '<leader>ccw', '<cmd>CopilotChatWording<cr>',
            { desc = 'CopilotChat - Improve wording' }
        )
        utils.map(
            mode, '<leader>ccc', '<cmd>CopilotChatConcise<cr>',
            { desc = 'CopilotChat - Make text concise' }
        )
    end
end

-- Misc
utils.map('n', '<leader>q', ':q<cr>', { desc = "Close current window"})
utils.map('n', '<leader>Q', ':qa<cr>', { desc = "Quit neovim" })
utils.map('n', '<leader>ex', ':e .<cr>', { desc = "Open Explorer" })
for _, mode in ipairs({'n', 'v'}) do
    utils.map(mode, '<tab>', '>><esc>', { silent = false, desc = "Indent right" })
    utils.map(mode, '<s-tab>', '<<<esc>', { silent = false, desc = "Indent left" })
end
utils.map(
    'i', '<s-tab>', '<esc><<', { silent = false, desc = "Indent left in insert mode" }
)
vim.cmd('cmap w!! w !sudo tee > /dev/null %', { desc = "Save file as sudo" })
vim.cmd('cmap <c-p> <c-r>*', { desc = "Paste from system clipboard in command mode" })
utils.mapfunc('n', '<leader>24i', function()
    utils.change_file_indent_size(2, 4)
end, { desc = "Change file indent size from 2 to 4" })
utils.mapfunc('n', '<leader>42i', function()
    utils.change_file_indent_size(4, 2)
end, { desc = "Change file indent size from 4 to 2" })
utils.map('n', ';', ':', { silent = false, desc = "Command line mode" })
utils.map('v', ';', ':', { silent = false, desc = "Command line mode in Visual mode" })
utils.map(
    'n', ',p', '"0p', { noremap = false, silent = false, desc = "Paste last yanked" }
)
utils.map(
    'n', ',P', '"0P',
    {
        noremap = false,
        silent = false,
        desc = "Paste last yanked before cursor position",
    }
)
if os.getenv("SSH_TTY") then
    local yanks = {'yy', 'yw', 'y^', 'y$', 'yiw', 'yaw'}
    for _, key in ipairs(yanks) do
            utils.map(
                'n', "<leader>" .. key, '"+' .. key,
                {
                    silent = false,
                    desc = "Yank to system clipboard if using the default " ..
                    "OSC 52 clipboard for Neovim"
                }
            )
    end
    utils.map(
        'v', '<leader>y', '"+y',
        {
            silent = false,
            desc = "Yank to system clipboard in Visual mode " ..
            "if using the default OSC 52 clipboard for Neovim"
        }
    )
end
