local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

-- TODO: Incremental selection? Educate yourself about treesitter
-- TODO: Folds, Locals, Indents, Injections
-- TODO: key mappings

treesitter_configs.setup({
  ensure_installed = { 'lua', 'python' },
  highlight = { enable = true, additional_vim_regex_highlighting = true },
})
