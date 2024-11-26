return {
  'mbbill/undotree',
  keys = {
    { '<leader>tu', ':UndotreeToggle<CR>' },
  },
  config = function()
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_SplitWidth = 50
    vim.g.undotree_HelpLine = 0
  end,
}
