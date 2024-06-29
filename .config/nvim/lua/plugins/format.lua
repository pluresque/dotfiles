return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      javascript = { { 'prettierd', 'prettier' } },
      php = { 'php' },
    },
    format_on_save = function(bufnr)
      return
    end,
    formatters = {
      shfmt = {
        prepend_args = { '-i', '2' },
      },
      php = {
        command = 'php-cs-fixer',
        args = {
          'fix',
          '$FILENAME',
        },
        stdin = false,
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
