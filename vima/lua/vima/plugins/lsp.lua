local status_ok, lsp_installer_servers = pcall(require, 'nvim-lsp-installer.servers')
if not status_ok then
  vim.notify('Failed to load lsp-installer.')
  return
end

local status_ok, lsp_signature = pcall(require, 'lsp_signature')
if not status_ok then
  vim.notify('Failed to load lsp_signature.')
  return
end

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  vim.notify('Failed to load cmp_nvim_lsp.')
  return
end

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
        augroup vima_lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
      false
    )
  end
end

local function lsp_keymaps(bufnr)
  local status_ok, which_key = pcall(require, 'which-key')
  if not status_ok then
    vim.notify('Failed to load which-key.')
    return
  end

  which_key.register({
    ['gd'] = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to definition' },
    ['gD'] = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to declaration' },
    ['gh'] = { '<cmd>lua vim.lsp.buf.hover({ border = "rounded" })<CR>', 'Hover' },
    ['gl'] = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>', 'Line diagnostics' },
    -- TODO: use Telescope for references and diagnostics
  }, { buffer = bufnr })
end

local on_attach = function(client, bufnr)
  -- TODO: format on save
  lsp_signature.on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = 'rounded',
    },
  }, bufnr)

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local setup_lsp = function(lang_lsp_configs)
  for lsp_name, lsp_config in pairs(lang_lsp_configs) do
    local server_available, requested_server = lsp_installer_servers.get_server(lsp_name)
    if server_available then
      requested_server:on_ready(function()
        requested_server:setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            if lsp_config.on_attach then
              lsp_config.on_attach(client, bufnr)
            end
            on_attach(client, bufnr)
          end,
          settings = lsp_config.settings,
        })
      end)
      if not requested_server:is_installed() then
        requested_server:install()
        vim.notify(lsp_name .. ' is being installed.')
      end
    end
  end
end

local null_ls_config = require('vima.plugins.null-ls')
require('vima.Languages').setup_supported_lsps(setup_lsp, null_ls_config.add_sources)
null_ls_config.setup_null_ls()

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
