-- Plugins
--------------------------------------------------------------------------------

local fn = vim.fn

-- TODO: null-ls

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
      'RRethy/nvim-base16',
      config = function()
        require('colorscheme')
      end,
    })

    -- Parser
    use({
      'nvim-treesitter/nvim-treesitter',
      branch = '0.5-compat',
      run = ':TSUpdate',
      event = 'BufRead',
      config = function()
        require('treesitter')
      end,
    })

    -- Language Servers
    use({
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
        require('languange_servers')
      end,
      requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer' },
    })

    -- Fuzzy finder
    -- TODO: Telescope key mappings
    -- TODO: Telescope customisations
    use({
      'nvim-telescope/telescope.nvim',
      requires = { { 'nvim-lua/plenary.nvim' } },
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
