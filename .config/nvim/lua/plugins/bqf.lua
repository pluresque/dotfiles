return {
  'kevinhwang91/nvim-bqf',
  config = function()
    require('bqf').setup {
      preview = {
        border = 'solid',
        show_scrollbar = false,
        winblend = 0,
      },
    }
  end,
}
