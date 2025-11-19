return {
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    keys = {
      {
        '<leader>tg',
        function()
          vim.cmd 'Neogit'
        end,
        desc = 'Neogit',
      },
    },

    dependencies = {
      'nvim-lua/plenary.nvim',
      "sindrets/diffview.nvim",
    },

    config = function()
      local neogit = require 'neogit'

      neogit.setup {
        disable_hint = false,
        disable_context_highlighting = false,
        disable_signs = false,
        disable_insert_on_commit = 'auto',
      }
    end,
  },
}
