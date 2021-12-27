local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup mynvim_packer_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Install plugins here
return packer.startup({
  function(use)
    use('wbthomason/packer.nvim') -- Have packer manage itself
    use('nvim-lua/popup.nvim') -- An implementation of the Popup API from vim in Neovim
    use('nvim-lua/plenary.nvim') -- Useful lua functions used by lots of plugins

    -- base16 colorscheme
    use({
      'RRethy/nvim-base16',
      config = function()
        require('mynvim.colorscheme')
      end,
    })

    -- TODO: Add plugins from neovim from scratch

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      require('packer').sync()
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
