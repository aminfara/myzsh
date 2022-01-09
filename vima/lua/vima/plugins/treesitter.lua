local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  vim.notify('Failed to load treesitter configs.')
  return
end

-- TODO: textobjects and movements
-- TODO: Folds, Locals, Indents, Injections
-- TODO: key mappings
-- TODO: incremental select

configs.setup({
  ensure_installed = require('vima.Languages').get_treesitter_languages(),
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true },
  rainbow = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = true,
  },
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
