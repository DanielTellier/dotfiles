return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            { "nvim-telescope/telescope-file-browser.nvim" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require('telescope.actions')
            telescope.setup({
                defaults ={
                    mappings = {
                        i = {
                            ["<c-o>"] = actions.select_horizontal,
                            -- Need to hold ctrl key and press 't' twice due to wezterm leader key being <c-t>
                            ["<c-t>"] = actions.select_tab,
                            ["<c-v>"] = actions.select_vertical,
                        },
                        n = {
                            ["<c-o>"] = actions.select_horizontal,
                            -- Need to hold ctrl key and press 't' twice due to wezterm leader key being <c-t>
                            ["<c-t>"] = actions.select_tab,
                            ["<c-v>"] = actions.select_vertical,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                    -- fuzzy matching
                        override_generic_sorter = true,  -- override default sorter
                        override_file_sorter = true,     -- override file sorter
                        case_mode = "smart_case",        -- "smart_case" | "ignore_case" | "respect_case"
                    }
                },
            })
            telescope.load_extension("fzf")
            telescope.load_extension("file_browser")
        end,
    },
}
