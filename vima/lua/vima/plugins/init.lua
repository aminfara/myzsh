local present, packer = pcall(require, 'packer')

if not present then
    local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

    vim.notify('Bootstrapping packer.nvim . . .')
    vim.fn.delete(packer_path, 'rf')
    PACKER_BOOTSTRAP = vim.fn.system({
        'git',
        'clone',
        'https://github.com/wbthomason/packer.nvim',
        '--depth',
        '20',
        packer_path,
    })
    vim.cmd('packadd packer.nvim')
    present, packer = pcall(require, 'packer')

    if present then
        vim.notify('Packer installed successfully.')
    else
        error('Could not bootstrap packer!')
        return false
    end
end

return packer.startup({
    function(use)
        -- Packer can manage itself
        use('wbthomason/packer.nvim')

        -- Speedup the start time
        use('lewis6991/impatient.nvim')

        -- utility functions used by other plugins

        use('nvim-lua/plenary.nvim')

        -- icons used by other plugins
        use({
            'kyazdani42/nvim-web-devicons',
            event = 'VimEnter',
            cond = function()
                return not vim.g.vscode
            end
        })

        --color scheme
        use({
            'RRethy/nvim-base16',
            config = function()
                require('vima.plugins.colorscheme')
            end,
            after = { 'nvim-web-devicons' },
            cond = function()
                return not vim.g.vscode
            end
        })

        -- Treesitter syntax support
        use({
            'nvim-treesitter/nvim-treesitter',
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
            config = function()
                require('vima.plugins.treesitter')
            end
        })

        use({
            'andymass/vim-matchup',
            after = { 'nvim-treesitter' },
            setup = function()
                -- may set any options here
                vim.g.matchup_matchparen_offscreen = { method = "popup" }
            end
        })

        use({
            'p00f/nvim-ts-rainbow', -- Rainbow brackets
            after = { 'nvim-treesitter' },
            cond = function()
                return not vim.g.vscode
            end
        })

        use({
            'nvim-treesitter/nvim-treesitter-textobjects',
            after = { 'nvim-treesitter' },
        })

        use({
            'JoosepAlviste/nvim-ts-context-commentstring',
            after = { 'nvim-treesitter' },
        })

        -- context aware commenting
        use({
            'numToStr/Comment.nvim',
            after = { 'nvim-ts-context-commentstring' },
            config = function()
                require('vima.plugins.comment')
            end,
        })

        -- Surround
        use({
            "kylechui/nvim-surround",
            tag = "*", -- Use for stability; omit to use `main` branch for the latest features
            config = function()
                require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                })
            end
        })

        -- Automatically set up your configuration after cloning packer.nvim
        if PACKER_BOOTSTRAP then
            vim.cmd('hi clear Pmenu')
            packer.sync()
        end
    end,
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'rounded' })
            end,
        },
    },
})
