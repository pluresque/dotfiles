return {
  {
    'ThePrimeagen/harpoon',
    lazy = true,
    keys = {
      {
        '<leader>a',
        function()
          local harpoon = require 'harpoon'
          harpoon:list():add()
        end,
        desc = 'Add harpoon mark',
      },
      {
        '<leader>1',
        function()
          local harpoon = require 'harpoon'
          harpoon:list():select(1)
        end,
      },
      {
        '<leader>2',
        function()
          local harpoon = require 'harpoon'
          harpoon:list():select(2)
        end,
      },
      {
        '<leader>3',
        function()
          local harpoon = require 'harpoon'
          harpoon:list():select(3)
        end,
      },
      {
        '<leader>4',
        function()
          local harpoon = require 'harpoon'
          harpoon:list():select(4)
        end,
      },
      {
        '<leader>5',
        function()
          local harpoon = require 'harpoon'
          harpoon:list():select(5)
        end,
      },
      {
        '<C-S-K>',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
      },
    },
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup {
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          key = function()
            return vim.fn.getcwd()
            -- return vim.loop.cwd()
          end,
        },
      }
    end,
  },
}
