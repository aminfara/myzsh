if vim.g.vscode then
    return
end

vim.g.base16colorspace = 256

local status_ok, _ = pcall(vim.cmd, 'source $HOME/.vimrc_background')
if not status_ok then
    status_ok, _ = pcall(vim.cmd, 'colorscheme base16-default-dark')
    if not status_ok then
        vim.notify('Failed to load base16 colorscheme.')
        return
    end
end

-- https://github.com/RRethy/nvim-base16/issues/32 fix telescope borders
vim.cmd([[highlight! link TelescopeSelection    Visual]])
vim.cmd([[highlight! link TelescopeNormal       Normal]])
vim.cmd([[highlight! link TelescopePromptNormal TelescopeNormal]])
vim.cmd([[highlight! link TelescopeBorder       TelescopeNormal]])
vim.cmd([[highlight! link TelescopePromptBorder TelescopeBorder]])
vim.cmd([[highlight! link TelescopeTitle        TelescopeBorder]])
vim.cmd([[highlight! link TelescopePromptTitle  TelescopeTitle]])
vim.cmd([[highlight! link TelescopeResultsTitle TelescopeTitle]])
vim.cmd([[highlight! link TelescopePreviewTitle TelescopeTitle]])
vim.cmd([[highlight! link TelescopePromptPrefix Identifier]])
