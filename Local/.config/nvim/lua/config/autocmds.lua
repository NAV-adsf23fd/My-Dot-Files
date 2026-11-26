-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")


local function fix_snacks_border()
  local muted_color = "#1e2030"

  -- Hàm con để lấy cấu hình màu hiện tại, chỉ sửa viền (fg) và giữ nguyên nền (bg)
  local function change_fg(group, color, is_bold)
    -- Lấy highlight thật của group (link = false để resolve nếu nó đang trỏ sang nhóm khác)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    
    -- Gắn màu viền mới
    hl.fg = color
    if is_bold then hl.bold = true end
    
    -- Ghi đè lại vào Neovim
    vim.api.nvim_set_hl(0, group, hl)
  end

  change_fg("SnacksPickerInputBorder", muted_color, false)
  change_fg("SnacksPickerInputTitle", muted_color, true)
  change_fg("SnacksPickerBorder", muted_color, false)
  change_fg("SnacksPickerTitle", muted_color, true)
end

-- 1. Bắt sự kiện khi load/đổi theme
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = fix_snacks_border,
})

-- 2. Bắt sự kiện khi Lazy nạp xong plugin
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = fix_snacks_border,
})