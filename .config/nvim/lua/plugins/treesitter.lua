return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'python',
        'rust',
        'bash',
        'html',
        'lua',
        'markdown',
        'vim',
        'yaml',
        'sql',
        'make',
        'go',
        'hcl',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = '<Tab>',
          scope_incremental = 'grc',
          node_decremental = '<S-Tab>',
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
