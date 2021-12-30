local M = {}

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
        augroup mynvim_lsp_document_highlight
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
  lsp_signature.on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = 'rounded',
    },
  }, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

M.setup_lsp = function(language_config)
  local server_available, requested_server = lsp_installer_servers.get_server(language_config.server_name)
  if server_available then
    requested_server:on_ready(function()
      requested_server:setup({

        capabilities = capabilities,

        on_attach = function(client, bufnr)
          if language_config.on_attach then
            language_config.on_attach(client, bufnr)
          end
          on_attach(client, bufnr)
        end,

        settings = language_config.server_settings,
      })
    end)
    if not requested_server:is_installed() then
      requested_server:install()
      vim.notify(language_config.server_name .. ' is being installed.')
    end
  end
end

return M
