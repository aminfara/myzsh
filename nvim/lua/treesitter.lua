local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

local opt = vim.opt

-- TODO: textobjects and movements
-- TODO: Folds, Locals, Indents, Injections
-- TODO: key mappings

treesitter_configs.setup({
  ensure_installed = { 'lua', 'python' },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
    indent = {
      enable = true,
    },
  },
})

opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
