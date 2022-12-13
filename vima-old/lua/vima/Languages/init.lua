local M = {}

local supported_languages = { 'lua' }

M.get_treesitter_languages = function()
  return supported_languages
end

M.setup_supported_lsps = function(setup_lsp, add_null_ls_sources)
  for _, lang in ipairs(supported_languages) do
    local lang_config = require('vima.Languages.' .. lang)
    setup_lsp(lang_config.get_lsp_configs())
    add_null_ls_sources(lang_config.get_null_ls_sources())
  end
end

return M
