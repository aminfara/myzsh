local status_ok, project_nvim = pcall(require, 'project_nvim')
if not status_ok then
  vim.notify('Failed to load project_nvim.')
  return
end

local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  vim.notify('Failed to load Telescope.')
  return
end

project_nvim.setup({})

telescope.load_extension('projects')
