local status_ok, nvim_lsp = pcall(require, 'lspconfig')
if not status_ok then
  return
end

local status_ok, lsp_installer_servers = pcall(require, 'nvim-lsp-installer.servers')
if not status_ok then
  return
end

local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return
end

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

-- TODO: Understand!
local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local server_available, requested_server = lsp_installer_servers.get_server('pyright')
if server_available then
  requested_server:on_ready(function()
    local opts = {
      capabilities = capabilities,
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

local sources = {
  null_ls.builtins.formatting.isort.with({
    condition = function(utils)
      return vim.fn.executable('isort') > 0
    end,
  }),

  null_ls.builtins.formatting.black.with({
    condition = function(utils)
      return vim.fn.executable('black') > 0
    end,
  }),

  null_ls.builtins.diagnostics.flake8.with({
    condition = function(utils)
      return vim.fn.executable('flake8') > 0
    end,
  }),
}

null_ls.config({
  sources = sources,
})

nvim_lsp['null-ls'].setup({
  autostart = true,
})
