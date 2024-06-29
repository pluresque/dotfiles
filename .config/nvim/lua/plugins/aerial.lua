return {
  'stevearc/aerial.nvim',
  event = 'BufRead',
  opts = {},
  config = function()
    require('aerial').setup {
      on_attach = function(bufnr)
        vim.keymap.set('n', '_', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '+', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    }
    vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
