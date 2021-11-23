local status_ok, lsp_installer_servers = pcall(require, 'nvim-lsp-installer.servers')
if not status_ok then
  print('bad!')
  return
end

local server_available, requested_server = lsp_installer_servers.get_server('pyright')
if server_available then
  requested_server:on_ready(function()
    local opts = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            autoImportCompletions = true,
            disableOrganizeImports = true,
            diagnosticMode = 'workspace',
            useLibraryCodeForTypes = true,
            typeCheckingMode = 'strict',
          },
        },
      },
    }
    requested_server:setup(opts)
  end)
  if not requested_server:is_installed() then
    requested_server:install()
  end
end
