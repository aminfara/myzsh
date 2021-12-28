local M = {}

M.server_name = 'pyright'

M.server_settings = {
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
}

M.on_attach = function(client, bufnr) end

return M
