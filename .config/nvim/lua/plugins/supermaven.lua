return {
  {
    'supermaven-inc/supermaven-nvim',
    cmd = 'SuperMavenToggle',
    event = 'InsertEnter',
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<C-y>',
          clear_suggestion = '<C-]>',
          accept_word = '<C-j>',
        },
      }
    end,
  },
}
