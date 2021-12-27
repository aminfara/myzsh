local cmd = vim.cmd
local notify = vim.notify
local g = vim.g

g.base16colorspace = 256

local status_ok, _ = pcall(cmd, 'source $HOME/.vimrc_background')
if status_ok then
  return
end

notify('Failed to load .vimrc_background.')

status_ok, _ = pcall(cmd, 'colorscheme base16-default-dark')
if not status_ok then
  notify('Failed to load base16 colorscheme.')
end
