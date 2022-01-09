local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  vim.notify('Failed to load which-key.')
  return
end

which_key.setup({
  window = {
    border = 'rounded',
  },
})

which_key.register({
  f = {
    name = 'find',
    b = { '<cmd>Telescope buffers<cr>', 'Buffers' },
    f = { '<cmd>Telescope find_files<cr>', 'Files' },
    g = { '<cmd>Telescope live_grep<cr>', 'Grep' },
    r = { '<cmd>Telescope oldfiles<cr>', 'Recent file' },
    s = { '<cmd>Telescope git_status<cr>', 'Git status' },
  },
  g = {
    name = 'Git',
    b = { '<cmd>Gitsigns stage_buffer<cr>', 'Stage file' },
    d = { '<cmd>Gitsigns diffthis<cr>', 'Diff current file' },
    n = { '<cmd>Gitsigns next_hunk<cr>', 'Next hunk' },
    p = { '<cmd>Gitsigns prev_hunk<cr>', 'Prev hunk' },
    r = { '<cmd>Gitsigns refresh<cr>', 'Refresh' },
    s = { '<cmd>Gitsigns stage_hunk<cr>', 'Stage hunk' },
    u = { '<cmd>Gitsigns undo_stage_hunk<cr>', 'Undo stage hunk' },
  },
  t = {
    name = 'Toggle',
    f = { '<cmd>NvimTreeToggle<cr>', 'NVIMTree' },
  },
}, { prefix = '<leader>' })
