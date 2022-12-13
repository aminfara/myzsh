local present, ts_configs = pcall(require, 'nvim-treesitter.configs')
if not present then
    require('vima.utils').notify_missing('nvim-treesitter')
    return
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
    group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    callback = function()
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
    end
})

ts_configs.setup({
    ensure_installed = { 'lua', 'python', 'bash', 'javascript', 'typescript' },
    sync_install = false,
    highlight = {
        enable = true,
        disable = function(lang, buf)
            if vim.g.vscode then
                return true
            else
                return false
            end
        end,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    rainbow = {
        enable = true,
    },
    matchup = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                ['ab'] = '@block.outer',
                ['ib'] = '@block.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
                ['a/'] = '@comment.outer',
                ['i/'] = '@comment.outer',
                ['ai'] = '@conditional.outer',
                ['ii'] = '@conditional.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['al'] = '@loop.outer',
                ['il'] = '@loop.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']b'] = '@block.outer',
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']B'] = '@block.outer',
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[b'] = '@block.outer',
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[B'] = '@block.outer',
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
    },
})
