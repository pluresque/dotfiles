return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader><space>', '<cmd>FzfLua files<cr>' },
      { '<leader>,', '<cmd>FzfLua buffers<cr>' },
      { '<leader>/', '<cmd>FzfLua live_grep<cr>' },
      { '<leader>.', '<cmd>FzfLua lsp_workspace_diagnostics<cr>' },
      { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'Go to definition' },
      { 'gD', '<cmd>FzfLua lsp_declarations<cr>', desc = 'Go to declaration' },
      { 'gi', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Go to implementation' },
      { 'gr', '<cmd>FzfLua lsp_references<cr>', desc = 'Go to references' },
      { 'go', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'Go to type definition' },
      { 'ga', '<cmd>FzfLua lsp_code_actions<cr>', desc = 'Code actions' },
      { '<leader>tk', '<cmd>FzfLua keymaps<cr>', desc = 'Toggle keymaps' },
    },
    config = function()
      require('fzf-lua').setup {
        winopts = {
          height = 0.95,
          width = 0.95,
          row = 0.35,
          col = 0.50,
          preview = {
            default = 'builtin',
            horizontal = 'right:50%'
          },
        },
        -- defaults = {
        --   multiline = 1
        -- },
        diagnostics = {
          multiline = 1
        }
      }
    end,
  },
}

