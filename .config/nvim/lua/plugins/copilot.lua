return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        auto_trigger = true,
        hide_during_completion = true,
      },
      keymap = {
        -- accept = '<c-y>',
        -- accept_word = false,
        accept_line = '<C-y>',
        -- next = '<M-]>',
        -- prev = '<M-[>',
        -- dismiss = '<C-]>',
      },
    }
  end,
}
