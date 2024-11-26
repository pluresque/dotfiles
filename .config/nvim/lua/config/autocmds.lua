local m = vim.keymap.set

local function augroup(name)
  return vim.api.nvim_create_augroup('core_' .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 300 }
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }
    m('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    m('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    m('n', 'lr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'help',
    'lspinfo',
    'checkhealth',
    'lazy',
    'neogitstatus',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', '<esc>', '<cmd>close<cr>', {
      buffer = event.buf,
      silent = true,
      desc = 'Quit buffer',
    })
    vim.keymap.set('n', 'q', '<cmd>close<cr>', {
      buffer = event.buf,
      silent = true,
      desc = 'Quit buffer',
    })
  end,
})

local format_summary = function(data)
  local summary = vim.b[data.buf].minigit_summary
  vim.b[data.buf].minigit_summary_string = summary.head_name or ''
end

local au_opts = { pattern = 'MiniGitUpdated', callback = format_summary }
vim.api.nvim_create_autocmd('User', au_opts)
