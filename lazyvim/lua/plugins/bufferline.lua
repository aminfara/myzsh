return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local bufferline = require("bufferline")
      opts.options.style_preset = bufferline.style_preset.no_italic
      return opts
    end,
  },
}
