-- Colour scheme
--------------------------------------------------------------------------------

local cmd = vim.cmd
local fn = vim.fn
local g = vim.g

g.base16colorspace = 256

-- Check if base16-shell setup the color scheme
if fn.empty(fn.glob('$HOME/.vimrc_background')) == 0 then
  cmd('source $HOME/.vimrc_background')
else
  cmd('colorscheme base16-default-dark')
end
