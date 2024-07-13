return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "cspell" } },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "davidmh/cspell.nvim" },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      local cspell = require("cspell")
      local config = {
        config_file_preferred_name = ".cspell.json",
      }
      table.insert(
        opts.sources,
        -- cspell.diagnostics
        cspell.diagnostics.with({
          config = config,
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["HINT"]
          end,
        })
      )
      table.insert(opts.sources, cspell.code_actions.with({ config = config }))
      -- table.insert(opts.sources, cspell.code_actions)
    end,
  },
}
