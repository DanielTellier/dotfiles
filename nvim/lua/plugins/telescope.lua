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
      { "fdschmidt93/telescope-egrepify.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "LinArcX/telescope-env.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require('telescope.actions')
      telescope.setup({
        defaults ={
          preview = { treesitter = true },
          color_devicons = true,
          sorting_strategy = "ascending",
          path_displays = { "smart" },
          borderchars = {
            "", -- top
            "", -- right
            "", -- bottom
            "", -- left
            "", -- top-left
            "", -- top-right
            "", -- bottom-right
            "", -- bottom-left
          },
          layout_config = {
            height = 100,
            width = 400,
            prompt_position = "top",
            preview_cutoff = 40,
          },
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
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<c-x>"] = require('telescope.actions').delete_buffer,
              },
              n = {
                ["<c-x>"] = require('telescope.actions').delete_buffer,
              },
            },
          },
        },
        extensions = {
          ["fzf"] = {
            fuzzy = true,                    -- fuzzy matching
            override_generic_sorter = true,  -- override default sorter
            override_file_sorter = true,     -- override file sorter
            case_mode = "smart_case",        -- "smart_case" | "ignore_case" | "respect_case"
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("egrepify")
      telescope.load_extension("ui-select")
      telescope.load_extension('env')
    end,
  },
}
