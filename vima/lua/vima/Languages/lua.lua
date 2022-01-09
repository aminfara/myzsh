local M = {}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local lsp_config = {
  Lua = {
    runtime = {

      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = 'LuaJIT',
      -- Setup your lua path
      path = runtime_path,
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = { 'vim' },
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = vim.api.nvim_get_runtime_file('', true),
    },
    -- Do not send telemetry data containing a randomized but unique identifier
    telemetry = {
      enable = false,
    },
  },
}

local status_ok, lua_dev = pcall(require, 'lua-dev')
if status_ok then
  lsp_config = lua_dev.setup({ lspconfig = lsp_config })
end

M.get_lsp_configs = function()
  return {
    sumneko_lua = {
      settings = lsp_config,
      on_attach = function(client, bufnr) end,
    },
  }
end

M.get_null_ls_sources = function()
  local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
  if not null_ls_status_ok then
    vim.notify('Failed to load null-ls.')
    return {}
  end
  return {
    null_ls.builtins.formatting.stylua.with({
      condition = function(utils)
        return vim.fn.executable('stylua') > 0
      end,
    }),
  }
end

return M
