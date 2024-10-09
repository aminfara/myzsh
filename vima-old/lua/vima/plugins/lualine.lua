local present, lualine = pcall(require, 'lualine')
if not present then
    require('vima.utils').notify_missing('lualine.nvim')
    return
end

-- TODO: hide, show on specific filetypes

-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/progress.lua
local function progress()
    local cur = vim.fn.line('.')
    local total = vim.fn.line('$')
    if cur == 1 then
        return 'Top'
    elseif cur == total then
        return 'Bot'
    else
        return string.format("%02d", math.floor(cur / total * 100)) .. '%%'
    end
end

lualine.setup({
    options = {
        section_separators = { left = ' ', right = ' ' },
        component_separators = { left = ' ', right = ' ' },
        disabled_filetypes = { 'alpha', 'NvimTree' },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename' },
        lualine_c = { 'branch', 'diff', 'diagnostics' },
        lualine_x = { 'filetype', 'encoding', 'fileformat' },
        lualine_y = { 'location', progress },
        lualine_z = { 'os.date("%H:%M")' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = { 'filename' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'location', 'progress' },
        lualine_z = {},
    },
})
