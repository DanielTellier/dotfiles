return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        config = function()
            local actions = require('telescope.actions')
            require("telescope").setup{
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
            }
        end,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").setup{
                        extensions = {
                            fzf = {
                                fuzzy = true,                    -- fuzzy matching
                                override_generic_sorter = true,  -- override default sorter
                                override_file_sorter = true,     -- override file sorter
                                case_mode = "smart_case",        -- "smart_case" | "ignore_case" | "respect_case"
                            }
                        },
                    }
                    require("telescope").load_extension("fzf")
                end,
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                config = function()
                    require("telescope").load_extension("file_browser")
                end,
            },
        },
    },
}
