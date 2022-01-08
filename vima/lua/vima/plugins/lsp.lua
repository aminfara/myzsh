local status_ok, lsp_installer_servers = pcall(require, 'nvim-lsp-installer.servers')
if not status_ok then
  vim.notify('Failed to load lsp-installer.')
  return
end

local setup_lsp = function(lang_lsp_configs)
  for lsp_name, lsp_config in pairs(lang_lsp_configs) do
    local server_available, requested_server = lsp_installer_servers.get_server(lsp_name)
    if server_available then
      requested_server:on_ready(function()
        requested_server:setup({
          -- TODO: Add on_attach and capabilities
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

-- TODO: better visual config for LSP popups
