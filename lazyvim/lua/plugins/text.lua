local words = {}
for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
  table.insert(words, word)
end

return {
  -- remove markdown from treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local ignore_install = { "markdown", "markdown_inline" }
      if type(opts.ignore_install) == "table" then
        vim.list_extend(ignore_install, opts.ignore_install)
      end
      opts.ignore_install = ignore_install
      return opts
    end,
  },

  -- ltex installation
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ltex = {
          settings = {
            ltex = {
              additionalRules = {
                motherTongue = "fa",
                enablePickyRules = "true"
              },
              dictionary = {
                ["en-US"] = words,
              },
            },
          }
        }
      }
    }
  }
}
