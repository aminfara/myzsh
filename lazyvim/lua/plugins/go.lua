return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "golangci-lint", "golangci-lint-langserver" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        golangci_lint_ls = {
          filetypes = { "go", "gomod" },
        },
      },
    },
  },
}
