local utils = require('utils')

utils.map({ "n", "o", "x" }, "s", function()
    require("flash").jump()
end, { desc = "Flash" })
utils.map({ "n", "o", "x" }, "S", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter" })
utils.map("o", "r", function()
    require("flash").remote()
end, { desc = "Flash Remote" })
utils.map({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
end, { desc = "Flash Treesitter Search" })
utils.map("c", "<c-s>", function()
    require("flash").toggle()
end, { desc = "Flash Toggle Search" })
utils.map("n", "<leader>j", function()
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
end, { desc = "2-char jump" })
