local status_ok, nvim_lsp = pcall(require, 'lspconfig')
if not status_ok then
  vim.notify('Failed to load lspconfig.')
  return
end

local lsp_installer = require('mynvim.lsp.lsp_installer')
local null_ls_config = require('mynvim.lsp.null_ls_config')

lsp_installer.setup_lsp(require('mynvim.lsp.languages.python'))

null_ls_config.add_sources(require('mynvim.lsp.languages.python'))

null_ls_config.setup_null_ls()

require('mynvim.lsp.lsp_common_setup').setup()
