return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    config = function()
      require('lint').linters_by_ft = {
        dockerfile = { 'hadolint' },
      }

      vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
        callback = function()
          local lint_status, lint = pcall(require, 'lint')
          if lint_status then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
