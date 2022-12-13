local M = {}

M.map = function(mode, keys, command, options_override)
  local options = { noremap = true, silent = true }
  options = vim.tbl_extend('force', options, options_override or {})
  vim.api.nvim_set_keymap(mode, keys, command, options)
end

return M
