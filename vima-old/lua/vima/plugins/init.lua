-- https://github.com/wbthomason/packer.nvim

-- Self install packer if not found on data path
local fn = vim.fn
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

    use('nvim-lua/popup.nvim')
    use('nvim-lua/plenary.nvim') -- utility functions used by other plugins
    use('kyazdani42/nvim-web-devicons')

    --color scheme
    use({
      'RRethy/nvim-base16',
      config = function()
        require('vima.plugins.colorscheme')
      end,
    })

    -- which-key shows possible keys
    use({
      'folke/which-key.nvim',
      config = function()
        require('vima.plugins.whichkey')
      end,
    })

    -- Treesitter syntax highlight
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
    })
    use({ 'JoosepAlviste/nvim-ts-context-commentstring', after = { 'nvim-treesitter' } })
    use({
      'p00f/nvim-ts-rainbow', -- Rainbow brackets
      after = { 'nvim-treesitter', 'nvim-ts-context-commentstring' },
      config = function()
        require('vima.plugins.treesitter')
      end,
    })

    -- git signs
    use({
      'lewis6991/gitsigns.nvim',
      config = function()
        require('vima.plugins.gitsigns')
      end,
    })

    -- file tree
    use({
      'kyazdani42/nvim-tree.lua',
      config = function()
        require('vima.plugins.nvimtree')
      end,
    })

    -- project
    use({
      'ahmedkhalf/project.nvim',
      config = function()
        require('vima.plugins.project')
      end,
    })

    -- autocomplete and snippets plugins
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-cmdline')
    use('saadparwaiz1/cmp_luasnip')
    use('L3MON4D3/LuaSnip')
    use('rafamadriz/friendly-snippets')
    use({
      'hrsh7th/nvim-cmp',
      config = function()
        require('vima.plugins.completion')
      end,
    })

    -- language servers
    use('neovim/nvim-lspconfig')
    use('folke/lua-dev.nvim')
    use('ray-x/lsp_signature.nvim')
    use('williamboman/nvim-lsp-installer')
    use({
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
        require('vima.plugins.lsp')
      end,
    })

    -- Telescope fuzzy finder
    use({
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('vima.plugins.telescope')
      end,
    })

    -- auto pairs
    use({
      'windwp/nvim-autopairs',
      config = function()
        require('vima.plugins.autopairs')
      end,
    })

    use({
      'numToStr/Comment.nvim',
      after = { 'nvim-ts-context-commentstring' },
      config = function()
        require('vima.plugins.comment')
      end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
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
