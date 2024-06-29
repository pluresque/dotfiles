return {
  {
    'nvimdev/indentmini.nvim',
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  { 'lewis6991/gitsigns.nvim', event = 'VeryLazy', config = true }
}
