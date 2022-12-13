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
