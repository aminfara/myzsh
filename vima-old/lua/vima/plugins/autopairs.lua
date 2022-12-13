local status_ok, npairs = pcall(require, 'nvim-autopairs')
if not status_ok then
  vim.notify('Failed to load autopairs.')
  return
end

npairs.setup({
  check_ts = true,
  ts_config = {},
  disable_filetype = { 'TelescopePrompt' },
  fast_wrap = { offset = 0 },
})

-- Map <CR>
-- https://github.com/windwp/nvim-autopairs#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  vim.notify('Failed to load nvim-cmp.')
  return
end

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
