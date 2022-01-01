local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
  vim.notify('Failed to load nvim-tree.')
  return
end

-- TODO: whichkey shortcut
nvim_tree.setup({
  auto_close = true,
  update_focused_file = {
    enable = true,
  },
})
