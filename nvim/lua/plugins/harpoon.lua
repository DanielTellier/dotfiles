local utils = require('utils')

local function cycle_list(list, cycle_type)
  cycle_type = cycle_type or "next"
  local length = list:length()
  local index = list._index
  if not index or index < 1 then
    return
  end

  if index > length then
    index = length
  end

  if cycle_type == "next" then
    index = index + 1
    if index > length then
      index = 1
    end
  else -- previous
    if index == 1 then
      index = length
    else
      index = index - 1
    end
  end

  list._index = index
  list:select(list._index)
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function(_, opts)
    local wk = require("which-key")
    local harpoon = require("harpoon")
    wk.add({
      { "<leader>h", group = "harpoon", mode = "n" }
    })

    harpoon:setup()
    local list = harpoon:list()

    utils.map("n", "<leader>ha", function()
      list:add()
    end, { desc = "Add file to harpoon" })
    utils.map("n", "<leader>ht", function()
      harpoon.ui:toggle_quick_menu(list)
    end, { desc = "Toggle harpoon menu" })
    for i = 1, 9 do
      utils.map("n", "<leader>h" .. i, function()
        list:select(i)
      end, { desc = "Go to harpoon file " .. i })
    end
    utils.map("n", "<leader>hp", function()
      cycle_list(list, "previous")
    end, { desc = "Go to previous harpoon file" })
    utils.map("n", "<leader>hn", function()
      cycle_list(list, "next")
    end, { desc = "Go to next harpoon file" })

    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
              results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
      }):find()
    end

    utils.map("n", "<leader>hs", function()
      toggle_telescope(list)
    end, { desc = "Open harpoon telescope window" })
  end,
}
