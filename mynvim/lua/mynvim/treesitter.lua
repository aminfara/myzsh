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
  ensure_installed = { 'lua', 'python' },
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { '' }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { '' }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true },
  rainbow = { enable = true },
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
