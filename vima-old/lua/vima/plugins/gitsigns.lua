local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
  vim.notify('Failed to load gitsigns.')
  return
end

-- TODO: define key maps in whichkey
gitsigns.setup({
  current_line_blame = true,
  current_line_blame_formatter_opts = {
    relative_time = true,
  },
})
