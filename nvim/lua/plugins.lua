-- Plugins
--------------------------------------------------------------------------------

local fn = vim.fn

-- Bootstrap packer if it is not installed
local packer_install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    packer_install_path,
  })
end

return require('packer').startup({
  function(use)
    -- Control packer with packer!
    use('wbthomason/packer.nvim')

    -- Activate colorscheme
    use({
      'chriskempson/base16-vim',
      config = function()
        require('colorscheme')
      end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    -- Open packer progress window in a floating window
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
    },
  },
})
