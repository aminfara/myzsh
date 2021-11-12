-- General vim options
local options = {
    mouse = 'a',
    number = true,
    relativenumber = true,
    scrolloff = 3,
    sidescrolloff = 5,
    wrap = false,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
