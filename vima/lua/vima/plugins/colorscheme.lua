vim.g.base16colorspace = 256

local status_ok, _ = pcall(vim.cmd, 'source $HOME/.vimrc_background')
if status_ok then
  return
end

status_ok, _ = pcall(vim.cmd, 'colorscheme base16-default-dark')
if not status_ok then
  vim.notify('Failed to load base16 colorscheme.')
end
