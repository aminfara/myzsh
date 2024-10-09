local present, comment = pcall(require, 'Comment')
if not present then
    require('vima.utils').notify_missing('Comment.nvim')
    return
end

local present, ts_context_commentstring = pcall(require, 'ts_context_commentstring')
if not present then
    require('vima.utils').notify_missing('nvim_ts_context_commentstring')
    return
end

require('Comment').setup({
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
