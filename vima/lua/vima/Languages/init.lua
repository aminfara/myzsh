local M = {}

local supported_languages = { 'lua' }

M.get_treesitter_languages = function()
  return supported_languages
end

return M
