return {
  'robitx/gp.nvim',
  config = function()
    local conf = {
      chat_user_prefix = '>',
      chat_template = require('gp.defaults').short_chat_template,
      providers = {
        copilot = {
          endpoint = 'https://api.githubcopilot.com/chat/completions',
          secret = { 'bash', '-c', "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'" },
        },
        anthropic = {
          endpoint = 'https://api.anthropic.com/v1/messages',
          secret = os.getenv 'ANTHROPIC_API_KEY',
        },
      },
    }
    require('gp').setup(conf)
  end,
  keys = {
    -- Chat commands
    { '<C-g>c', '<cmd>GpChatNew<cr>', mode = { 'n', 'i' }, desc = 'New Chat' },
    { '<C-g>t', '<cmd>GpChatToggle<cr>', mode = { 'n', 'i' }, desc = 'Toggle Chat' },
    { '<C-g>f', '<cmd>GpChatFinder<cr>', mode = { 'n', 'i' }, desc = 'Chat Finder' },
    { '<C-g>c', ":<C-u>'<,'>GpChatNew<cr>", mode = 'v', desc = 'Visual Chat New' },
    { '<C-g>p', ":<C-u>'<,'>GpChatPaste<cr>", mode = 'v', desc = 'Visual Chat Paste' },
    { '<C-g>t', ":<C-u>'<,'>GpChatToggle<cr>", mode = 'v', desc = 'Visual Toggle Chat' },
    { '<C-g><C-x>', '<cmd>GpChatNew split<cr>', mode = { 'n', 'i' }, desc = 'New Chat split' },
    { '<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', mode = { 'n', 'i' }, desc = 'New Chat vsplit' },
    { '<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', mode = { 'n', 'i' }, desc = 'New Chat tabnew' },
    { '<C-g><C-x>', ":<C-u>'<,'>GpChatNew split<cr>", mode = 'v', desc = 'Visual Chat New split' },
    { '<C-g><C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", mode = 'v', desc = 'Visual Chat New vsplit' },
    { '<C-g><C-t>', ":<C-u>'<,'>GpChatNew tabnew<cr>", mode = 'v', desc = 'Visual Chat New tabnew' },

    -- Prompt commands
    { '<C-g>r', '<cmd>GpRewrite<cr>', mode = { 'n', 'i' }, desc = 'Inline Rewrite' },
    { '<C-g>a', '<cmd>GpAppend<cr>', mode = { 'n', 'i' }, desc = 'Append (after)' },
    { '<C-g>b', '<cmd>GpPrepend<cr>', mode = { 'n', 'i' }, desc = 'Prepend (before)' },
    { '<C-g>r', ":<C-u>'<,'>GpRewrite<cr>", mode = 'v', desc = 'Visual Rewrite' },
    { '<C-g>a', ":<C-u>'<,'>GpAppend<cr>", mode = 'v', desc = 'Visual Append (after)' },
    { '<C-g>b', ":<C-u>'<,'>GpPrepend<cr>", mode = 'v', desc = 'Visual Prepend (before)' },
    { '<C-g>i', ":<C-u>'<,'>GpImplement<cr>", mode = 'v', desc = 'Implement selection' },

    -- Whisper commands
    { '<C-g>ww', '<cmd>GpWhisper<cr>', mode = { 'n', 'i' }, desc = 'Whisper' },
    { '<C-g>wr', '<cmd>GpWhisperRewrite<cr>', mode = { 'n', 'i' }, desc = 'Whisper Inline Rewrite' },
    { '<C-g>wa', '<cmd>GpWhisperAppend<cr>', mode = { 'n', 'i' }, desc = 'Whisper Append (after)' },
    { '<C-g>wb', '<cmd>GpWhisperPrepend<cr>', mode = { 'n', 'i' }, desc = 'Whisper Prepend (before)' },
    { '<C-g>wp', '<cmd>GpWhisperPopup<cr>', mode = { 'n', 'i' }, desc = 'Whisper Popup' },
    { '<C-g>we', '<cmd>GpWhisperEnew<cr>', mode = { 'n', 'i' }, desc = 'Whisper Enew' },
    { '<C-g>wn', '<cmd>GpWhisperNew<cr>', mode = { 'n', 'i' }, desc = 'Whisper New' },
    { '<C-g>wv', '<cmd>GpWhisperVnew<cr>', mode = { 'n', 'i' }, desc = 'Whisper Vnew' },
    { '<C-g>wt', '<cmd>GpWhisperTabnew<cr>', mode = { 'n', 'i' }, desc = 'Whisper Tabnew' },
    { '<C-g>wr', ":<C-u>'<,'>GpWhisperRewrite<cr>", mode = 'v', desc = 'Visual Whisper Rewrite' },
    { '<C-g>wa', ":<C-u>'<,'>GpWhisperAppend<cr>", mode = 'v', desc = 'Visual Whisper Append (after)' },
    { '<C-g>wb', ":<C-u>'<,'>GpWhisperPrepend<cr>", mode = 'v', desc = 'Visual Whisper Prepend (before)' },
    { '<C-g>wp', ":<C-u>'<,'>GpWhisperPopup<cr>", mode = 'v', desc = 'Visual Whisper Popup' },
    { '<C-g>we', ":<C-u>'<,'>GpWhisperEnew<cr>", mode = 'v', desc = 'Visual Whisper Enew' },
    { '<C-g>wn', ":<C-u>'<,'>GpWhisperNew<cr>", mode = 'v', desc = 'Visual Whisper New' },
    { '<C-g>wv', ":<C-u>'<,'>GpWhisperVnew<cr>", mode = 'v', desc = 'Visual Whisper Vnew' },
    { '<C-g>wt', ":<C-u>'<,'>GpWhisperTabnew<cr>", mode = 'v', desc = 'Visual Whisper Tabnew' },
  },
}
