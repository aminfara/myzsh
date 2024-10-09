local present, pounce = pcall(require, 'pounce')
if not present then
    require('vima.utils').notify_missing('pounce.nvim')
    return
end

local map = vim.keymap.set

pounce.setup({})

map({'n', 'v'}, 's', '<cmd>Pounce<CR>')
map({'n', 'v'}, 'S', '<cmd>PounceRepeat<CR>')
