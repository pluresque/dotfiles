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
