local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  vim.notify('Failed to load which-key.')
  return
end

which_key.setup({
  window = {
    border = 'rounded',
  },
})
