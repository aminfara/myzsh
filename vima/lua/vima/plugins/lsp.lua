local status_ok, lsp_installer_servers = pcall(require, 'nvim-lsp-installer.servers')
if not status_ok then
  vim.notify('Failed to load lsp-installer.')
  return
end

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  vim.notify('Failed to load cmp_nvim_lsp.')
  return
end

-- local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local setup_lsp = function(lang_lsp_configs)
  for lsp_name, lsp_config in pairs(lang_lsp_configs) do
    local server_available, requested_server = lsp_installer_servers.get_server(lsp_name)
    if server_available then
      requested_server:on_ready(function()
        requested_server:setup({
          -- TODO: Add on_attach
          capabilities = capabilities,
          settings = lsp_config,
        })
      end)
      if not requested_server:is_installed() then
        requested_server:install()
        vim.notify(lsp_name .. ' is being installed.')
      end
    end
  end
end

require('vima.Languages').setup_supported_lsps(setup_lsp)

-- LSP Common config

local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

vim.diagnostic.config({
  virtual_text = true,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})
