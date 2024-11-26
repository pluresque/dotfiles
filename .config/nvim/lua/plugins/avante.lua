return {
  'yetone/avante.nvim',
  lazy = true,
  emabled = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'zbirenbaum/copilot.lua', -- for providers='copilot'
  },
}
