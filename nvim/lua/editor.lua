return {
    -- Use mini.icon for better performance
    {
        "echasnovski/mini.icons",
        opts = {
            file = {
                [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
                ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
            },
            filetype = {
                dotenv = { glyph = "", hl = "MiniIconsYellow" },
            },
        },
        config = function(_, options)
            local icons = require("mini.icons")
            icons.setup(options)
            -- Mocking methods of 'nvim-tree/nvim-web-devicons' for better integrations with plugins outside 'mini.nvim'
            icons.mock_nvim_web_devicons()
        end,
    },
    -- Tabline
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
            { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
            { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
        },
        opts = {
            options = {
                always_show_bufferline = false,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
        config = function(_, opts)
            require("bufferline").setup(opts)
            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
                callback = function()
                    vim.schedule(function()
                        pcall(nvim_bufferline)
                    end)
                end,
            })
        end,
    },
    -- Status line
    {
        "echasnovski/mini.statusline",
        opts = {
            set_vim_settings = false,
            content = {
                active = function()
                    local MiniStatusline = require("mini.statusline")
                    local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                    local git = MiniStatusline.section_git({ trunc_width = 40 })
                    local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                    local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
                    return MiniStatusline.combine_groups({
                        { hl = mode_hl, strings = { mode:upper() } },
                        "%<", -- Mark general truncate point
                        { hl = "MiniStatuslineFilename", strings = { filename } },
                        "%=", -- End left alignment
                        {
                            hl = "MiniStatuslineFileinfo",
                            strings = {
                                vim.bo.filetype ~= ""
                                    and require("mini.icons").get("filetype", vim.bo.filetype) .. " " .. vim.bo.filetype,
                            },
                        },
                        { hl = mode_hl, strings = { "%l:%v" } },
                    })
                end,
            },
        },
    },
    -- Remove buffer
    {
        "echasnovski/mini.bufremove",
        keys = {
            {
                "<S-q>",
                desc = "Delete buffer",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
            },
            {
                "<C-q>",
                desc = "Delete buffer",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
            },
        },
    },
    -- Indent
    {
        "echasnovski/mini.indentscope",
        version = false,
        event = "VeryLazy",
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            -- Disable mini.indentscope for some filetypes
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "dashboard",
                    "fzf",
                    "help",
                    "lazy",
                    "mason",
                    "toggleterm",
                    "Trouble",
                    "trouble",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },
    -- Which key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = {
            defaults = {},
            ---@type false | "classic" | "modern" | "helix"
            preset = vim.g.which_key_preset or "helix", -- default is "classic"
            -- Custom helix layout
            win = vim.g.which_key_window or {
                width = { min = 30, max = 60 },
                height = { min = 4, max = 0.85 },
            },
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader><tab>", group = "tabs" },
                    { "<leader>b", group = "buffer" },
                    { "<leader>c", group = "code" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>q", group = "quit/session" },
                    { "<leader>s", group = "search" },
                    { "<leader>t", group = "toggle" },
                    { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                    { "<leader>w", group = "windows" },
                    { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "gs", group = "surround" },
                    { "z", group = "fold" },
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Keymaps (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            if not vim.tbl_isempty(opts.defaults) then
                wk.register(opts.defaults)
            end
        end,
    },
    -- Better UI
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        config = function(_, opts)
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then
                vim.cmd([[messages clear]])
            end
            require("noice").setup(opts)
        end,
    },
    -- Navigate text with flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        vscode = true, -- Enable this plugin for vscode
        ---@type Flash.Config
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
            {
                "<leader>j",
                mode = { "n" },
                function()
                    local Flash = require("flash")

                    ---@param opts Flash.Format
                    local function format(opts)
                        -- always show first and second label
                        return {
                            { opts.match.label1, "FlashMatch" },
                            { opts.match.label2, "FlashLabel" },
                        }
                    end

                    Flash.jump({
                        search = { mode = "search" },
                        label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
                        pattern = [[\<]],
                        action = function(match, state)
                            state:hide()
                            Flash.jump({
                                search = { max_length = 0 },
                                highlight = { matches = false },
                                label = { format = format },
                                matcher = function(win)
                                    -- limit matches to the current label
                                    return vim.tbl_filter(function(m)
                                        return m.label == match.label and m.win == win
                                    end, state.results)
                                end,
                                labeler = function(matches)
                                    for _, m in ipairs(matches) do
                                        m.label = m.label2 -- use the second label
                                    end
                                end,
                            })
                        end,
                        labeler = function(matches, state)
                            local labels = state:labels()
                            for m, match in ipairs(matches) do
                                match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                                match.label2 = labels[(m - 1) % #labels + 1]
                                match.label = match.label1
                            end
                        end,
                    })
                end,
                desc = "2-char jump",
            },
        },
    },
    -- Use gs for surround as `s` is used by flash
    {
        "echasnovski/mini.surround",
        vscode = true,
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
        },
    },
    -- Mini pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        vscode = true,
        opts = {},
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    -- color schemes
    {
        "navarasu/onedark.nvim",
        lazy = false,
        config = function()
            require("onedark").setup({
                style = "cool"
            })
            require("onedark").load()
        end,
    },
    -- end color schemes
    { "sindrets/diffview.nvim" },
    { "tpope/vim-commentary" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-repeat" },
}
