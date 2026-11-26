local M = {}

local function load_colors()
  local colors = {}
  local path = vim.fn.expand("~/Applications/Config/MyScripts/Theme/colors.sh")
  local f = io.open(path, "r")
  if not f then return colors end

  for line in f:lines() do
    local key, val = line:match('^export%s+([%w_]+)="([^"]+)"')
    if key and val then
      local ref = val:match('^%${([%w_]+)}$')
      if ref and colors[ref] then
        colors[key] = colors[ref]
      else
        colors[key] = val
      end
    end
  end
  f:close()
  return colors
end

function M.setup()
  local c = load_colors()
  if not c.BACKGROUND then return end

  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "my_theme"

  local hl = vim.api.nvim_set_hl

  -- 1. Giao diện lõi & Explorer (Snacks)
  hl(0, "Normal",                { fg = c.ST_FG,         bg = c.BACKGROUND })
  hl(0, "NormalNC",              { fg = c.ST_FG,         bg = c.BACKGROUND })
  hl(0, "NormalFloat",           { fg = c.ST_FG,         bg = c.BACKGROUND })
  hl(0, "FloatBorder",           { fg = c.SUB_BACKGROUND,bg = c.BACKGROUND })
  hl(0, "CursorLine",            { bg = c.SUB_BACKGROUND })
  hl(0, "LineNr",                { fg = c.SUB_HIGHLIGHT })
  hl(0, "CursorLineNr",          { fg = c.HIGHLIGHT,     bold = true })
  hl(0, "SignColumn",            { bg = c.BACKGROUND })
  hl(0, "Visual", { fg = c.BACKGROUND, bg = c.SUB_HIGHLIGHT, bold = true })
  hl(0, "Search",                { fg = c.BACKGROUND,    bg = c.YELLOW })
  hl(0, "WinSeparator",          { fg = c.SUB_BACKGROUND,bg = c.BACKGROUND })
  hl(0, "Directory",             { fg = c.BLUE })

  -- Snacks Explorer & Picker
  hl(0, "SnacksNormal",          { fg = c.ST_FG,         bg = c.BACKGROUND })
  hl(0, "SnacksNormalNC",        { fg = c.ST_FG,         bg = c.BACKGROUND })
  hl(0, "SnacksPickerInput",     { fg = c.COLOR15,       bg = c.BACKGROUND })
  hl(0, "SnacksPickerInputBorder",{ fg = c.SUB_BACKGROUND,bg = c.BACKGROUND })
  hl(0, "SnacksPickerBorder",    { fg = c.SUB_BACKGROUND,bg = c.BACKGROUND })
  hl(0, "SnacksPickerListCursorLine", { bg = c.SUB_BACKGROUND })

  -- 2. Thanh Tab phía trên (Bufferline)
  hl(0, "TabLineFill",           { bg = c.BACKGROUND })
  hl(0, "BufferLineFill",        { bg = c.BACKGROUND })
  hl(0, "BufferLineBackground",  { fg = c.SUB_HIGHLIGHT, bg = c.BACKGROUND })
  hl(0, "BufferLineBuffer",      { fg = c.SUB_HIGHLIGHT, bg = c.BACKGROUND })
  hl(0, "BufferLineBufferSelected", { fg = c.COLOR15,    bg = c.SUB_BACKGROUND, bold = true })
  hl(0, "BufferLineBufferVisible",  { fg = c.HIGHLIGHT,  bg = c.BACKGROUND })
  hl(0, "BufferLineSeparator",   { fg = c.BACKGROUND,    bg = c.BACKGROUND })
  hl(0, "BufferLineSeparatorSelected", { fg = c.BACKGROUND, bg = c.SUB_BACKGROUND })
  hl(0, "BufferLineSeparatorVisible",  { fg = c.BACKGROUND, bg = c.BACKGROUND })
  hl(0, "BufferLineIndicatorSelected", { fg = c.HIGHLIGHT,  bg = c.SUB_BACKGROUND })
  hl(0, "BufferLineCloseButton", { fg = c.SUB_HIGHLIGHT, bg = c.BACKGROUND })
  hl(0, "BufferLineCloseButtonSelected", { fg = c.RED,   bg = c.SUB_BACKGROUND })

  -- 3. Thanh trạng thái dưới cùng (Lualine / StatusLine)
  hl(0, "StatusLine",            { fg = c.HIGHLIGHT,     bg = c.BACKGROUND })
  hl(0, "StatusLineNC",          { fg = c.SUB_HIGHLIGHT, bg = c.BACKGROUND })

  -- 4. Highlight cú pháp code (C/C++ & Treesitter)
  hl(0, "Comment",               { fg = c.SUB_HIGHLIGHT, italic = true })
  hl(0, "String",                { fg = c.GREEN })
  hl(0, "Number",                { fg = c.YELLOW })
  hl(0, "Function",              { fg = c.BLUE })
  hl(0, "Keyword",               { fg = c.COLOR13,       bold = true })
  hl(0, "Statement",             { fg = c.COLOR13 })
  hl(0, "PreProc",               { fg = c.COLOR13 })
  hl(0, "Type",                  { fg = c.YELLOW })
  hl(0, "Constant",              { fg = c.RED })
  hl(0, "Identifier",            { fg = c.COLOR15 })
  hl(0, "Operator",              { fg = c.HIGHLIGHT })
  hl(0, "Delimiter",             { fg = c.SUB_HIGHLIGHT })
  hl(0, "Error",                 { fg = c.RED,           bold = true })

  -- Ánh xạ Treesitter về các nhóm chuẩn ở trên
  local ts_links = {
    ["@comment"] = "Comment",
    ["@string"] = "String",
    ["@number"] = "Number",
    ["@function"] = "Function",
    ["@function.call"] = "Function",
    ["@method"] = "Function",
    ["@keyword"] = "Keyword",
    ["@keyword.import"] = "PreProc",
    ["@type"] = "Type",
    ["@type.builtin"] = "Type",
    ["@constant"] = "Constant",
    ["@variable"] = "Identifier",
    ["@property"] = "Identifier",
    ["@operator"] = "Operator",
    ["@punctuation"] = "Delimiter",
  }
  for group, target in pairs(ts_links) do
    hl(0, group, { link = target })
  end
end

return M
