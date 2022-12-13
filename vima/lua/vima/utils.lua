local M = {}

M.notify_missing = function(name, title)
  title = title or name
  vim.notify('Could not find ' .. name .. '.', 'warn', { title = title })
end

return M
