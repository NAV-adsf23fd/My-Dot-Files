return {
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("my_theme").setup()
      end,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local base = {
        a = { fg = "#000000", bg = "#959595", gui = "bold" },
        b = { fg = "#959595", bg = "#242424" },
        c = { fg = "#787878", bg = "#000000" },
      }
      opts.options.theme = {
        normal = base,
        insert = { a = { fg = "#000000", bg = "#76a170", gui = "bold" }, b = base.b, c = base.c },
        visual = { a = { fg = "#000000", bg = "#91966d", gui = "bold" }, b = base.b, c = base.c },
        command = { a = { fg = "#000000", bg = "#6e9494", gui = "bold" }, b = base.b, c = base.c },
        inactive = { a = base.c, b = base.c, c = base.c },
      }
    end,
  },
}
