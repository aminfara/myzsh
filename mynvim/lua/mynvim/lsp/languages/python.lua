local M = {}

local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
  vim.notify('Failed to load null-ls.')
  return
end

M.server_name = 'pyright'

M.server_settings = {
  pyright = {
    disableOrganizeImports = true,
  },
  python = {
    analysis = {
      autoSearchPaths = true,
      autoImportCompletions = true,
      diagnosticMode = 'workspace',
      useLibraryCodeForTypes = true,
      typeCheckingMode = 'strict',
    },
  },
}

M.on_attach = function(client, bufnr) end

M.null_ls_sources = {
  null_ls.builtins.formatting.isort.with({
    condition = function(utils)
      return vim.fn.executable('isort') > 0
    end,
    prefer_local = '.venv/bin',
  }),

  null_ls.builtins.formatting.black.with({
    condition = function(utils)
      return vim.fn.executable('black') > 0
    end,
    prefer_local = '.venv/bin',
  }),

  null_ls.builtins.diagnostics.flake8.with({
    condition = function(utils)
      return vim.fn.executable('flake8') > 0
    end,
    prefer_local = '.venv/bin',
  }),

  null_ls.builtins.diagnostics.mypy.with({
    condition = function(utils)
      return vim.fn.executable('mypy') > 0
    end,
    prefer_local = '.venv/bin',
    timeout = 10000,
  }),
}

return M
