local M = {}

local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
  vim.notify('Failed to load null-ls.')
  return
end

local sources = {}

M.add_sources = function(null_ls_sources)
  sources = vim.tbl_deep_extend('force', null_ls_sources, sources)
end

M.setup_null_ls = function()
  null_ls.setup({
    debug = false,
    update_in_insert = true,
    sources = sources,
  })
end

return M
