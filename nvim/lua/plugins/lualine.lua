local theme = function()
  local colors = {
    lightgray = "#D3D3D3",
    innerbg = nil,
    outerbg = "#16161D",
    normal = "#7e9cd8",
    insert = "#98bb6c",
    visual = "#ffa066",
    replace = "#e46876",
    command = "#e6c384",
  }
  return {
    inactive = {
      a = { fg = colors.lightgray, bg = colors.outerbg, gui = "bold" },
      b = { fg = colors.lightgray, bg = colors.outerbg },
      c = { fg = colors.lightgray, bg = colors.innerbg },
    },
    visual = {
      a = { fg = colors.lightgray, bg = colors.visual, gui = "bold" },
      b = { fg = colors.lightgray, bg = colors.outerbg },
      c = { fg = colors.lightgray, bg = colors.innerbg },
    },
    replace = {
      a = { fg = colors.lightgray, bg = colors.replace, gui = "bold" },
      b = { fg = colors.lightgray, bg = colors.outerbg },
      c = { fg = colors.lightgray, bg = colors.innerbg },
    },
    normal = {
      a = { fg = colors.lightgray, bg = colors.normal, gui = "bold" },
      b = { fg = colors.lightgray, bg = colors.outerbg },
      c = { fg = colors.lightgray, bg = colors.innerbg },
    },
    insert = {
      a = { fg = colors.lightgray, bg = colors.insert, gui = "bold" },
      b = { fg = colors.lightgray, bg = colors.outerbg },
      c = { fg = colors.lightgray, bg = colors.innerbg },
    },
    command = {
      a = { fg = colors.lightgray, bg = colors.command, gui = "bold" },
      b = { fg = colors.lightgray, bg = colors.outerbg },
      c = { fg = colors.lightgray, bg = colors.innerbg },
    },
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts ={
      icons_enabled = true,
      theme = theme,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
}
