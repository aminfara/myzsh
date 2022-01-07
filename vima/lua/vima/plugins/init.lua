-- https://github.com/wbthomason/packer.nvim

-- Self install packer if not found on data path
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  vim.cmd([[packadd packer.nvim]]) -- necessary to let us require packer on first run
end

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  vim.notify('Failed to load packer.nvim.')
  return
end

return packer.startup({
  function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    --color scheme
    use({
      'RRethy/nvim-base16',
      config = function()
        require('vima.plugins.colorscheme')
      end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
      vim.cmd('hi clear Pmenu')
      packer.sync()
    end
  end,
  config = {
    display = {
      -- Have packer use a popup window
      open_fn = function()
        return require('packer.util').float({ border = 'rounded' })
      end,
    },
  },
})
