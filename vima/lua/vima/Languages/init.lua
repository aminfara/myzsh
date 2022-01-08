local M = {}

local supported_languages = { 'lua' }

M.get_treesitter_languages = function()
  return supported_languages
end

M.setup_supported_lsps = function(setup_lsp)
  for _, lang in ipairs(supported_languages) do
    local lang_config = require('vima.Languages.' .. lang)
    setup_lsp(lang_config.get_lsp_configs())
  end
end

return M
