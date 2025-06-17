return {
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
            spec = {},
        },
        keys = {
            scroll_down = "<c-d>",
            scroll_up = "<c-u>",
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            if not vim.tbl_isempty(opts.defaults) then
                wk.register(opts.defaults)
            end
        end,
    },
    -- Navigate text with flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            enable_check_bracket_line = false,
            ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
        },
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
    { "tpope/vim-surround" },
}
