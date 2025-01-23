return {
  'stevearc/aerial.nvim',
  opts = {},
  keys = {
    { '<leader>ta', '<cmd>AerialToggle!<CR>', mode = 'n', desc = 'Toggle aerial' },
  },
  config = function()
    require('aerial').setup {
      on_attach = function(bufnr)
        vim.keymap.set('n', '_', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '+', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    }
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}
