local present, custom_plugins = pcall(require, 'core.customPlugins')
if present then
  custom_plugins.add(function(use)
    use({
      'folke/which-key.nvim',
      config = function()
        require('which-key').setup({})
      end,
      event = 'VimEnter'
    })
  end)
end
