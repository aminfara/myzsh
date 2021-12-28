local status_ok, nvim_lsp = pcall(require, 'lspconfig')
if not status_ok then
  vim.notify('Failed to load lspconfig.')
  return
end

local lsp_installer = require('mynvim.lsp.lsp_installer')

lsp_installer.setup_lsp(require('mynvim.lsp.languages.python'))

require('mynvim.lsp.lsp_common_setup').setup()
