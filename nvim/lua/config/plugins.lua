vim.pack.add({
  -- Theme
  { src = "https://github.com/sainnhe/gruvbox-material", name = "gruvbox-material" },

  -- Core
  { src = "https://github.com/echasnovski/mini.nvim", name = "mini" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
  { src = "https://github.com/saghen/blink.cmp", name = "blink-cmp", version = vim.version.range("1.*") },

  -- Navigation
  { src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
  { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary" },
  { src = "https://github.com/folke/flash.nvim", name = "flash" },
  { src = "https://github.com/stevearc/aerial.nvim", name = "aerial" },

  -- Editing
  { src = "https://github.com/stevearc/conform.nvim", name = "conform" },
  { src = "https://github.com/mfussenegger/nvim-lint", name = "nvim-lint" },
  { src = "https://github.com/mbbill/undotree", name = "undotree" },

  -- Git
  { src = "https://github.com/NeogitOrg/neogit", name = "neogit" },

  -- Languages
  { src = "https://github.com/mrcjkb/rustaceanvim" },
  { src = "https://github.com/mistweaverco/kulala.nvim", name = "kulala" },

  -- Tools
  { src = "https://github.com/toppair/peek.nvim", name = "peek" },
  { src = "https://github.com/esmuellert/codediff.nvim", name = "codediff" },
  { src = "https://github.com/MunifTanjim/nui.nvim", name = "nui" },
  { src = "https://github.com/wakatime/vim-wakatime", name = "vim-wakatime" },
})

-- Load all opt plugins
local plugins = {
  'gruvbox-material', 'mini', 'nvim-treesitter', 'nvim-lspconfig', 'blink-cmp',
  'fzf-lua', 'plenary', 'flash', 'aerial',
  'conform', 'nvim-lint', 'undotree',
  'neogit', 'rustaceanvim', 'kulala',
  'peek', 'codediff', 'nui', 'vim-wakatime',
}
for _, name in ipairs(plugins) do
  vim.cmd('packadd ' .. name)
end

----------------------------------------------------------------------
-- Theme
----------------------------------------------------------------------
vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_background = 'hard'
vim.cmd.colorscheme('gruvbox-material')

----------------------------------------------------------------------
-- Treesitter
----------------------------------------------------------------------
require('nvim-treesitter').setup()

----------------------------------------------------------------------
-- LSP
----------------------------------------------------------------------
local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = {
  pyright = {},
  ruff = {},
  omnisharp = {},
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          kubernetes = 'k8s-*.yaml',
          ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
          ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
          ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] =
          'docker-compose*.{yml,yaml}',
          ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json'] =
          'argocd-application.yaml',
          ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/**/*.{yml,yaml}',
          ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
          ['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
          ['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
          ['http://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}',
        },
      },
    },
  },
  phpactor = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = { vim.env.VIMRUNTIME } },
      },
    },
  },
}

for server_name, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(server_name, config)
end

local function organize_imports()
  vim.lsp.buf_request(0, 'workspace/executeCommand', {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
  })
end

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  commands = {
    OrganizeImports = { organize_imports, description = 'Organize Imports' },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('lsp-enable', { clear = true }),
  callback = function()
    for server_name, _ in pairs(servers) do
      vim.lsp.enable(server_name)
    end
    vim.lsp.enable('ts_ls')
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Document highlight
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = event.buf, group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorHoldI', {
        buffer = event.buf, group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = event.buf, group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('CursorMovedI', {
        buffer = event.buf, group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay hints toggle
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      vim.keymap.set('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, { buffer = event.buf, desc = 'LSP: Toggle Inlay Hints' })
    end

    -- Code lens
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd("BufEnter", { buffer = event.buf, callback = vim.lsp.codelens.refresh })
      vim.api.nvim_create_autocmd("CursorHold", { buffer = event.buf, callback = vim.lsp.codelens.refresh })
      vim.api.nvim_create_autocmd("InsertLeave", { buffer = event.buf, callback = vim.lsp.codelens.refresh })
    end
  end,
})

----------------------------------------------------------------------
-- Completion (blink.cmp)
----------------------------------------------------------------------
require('blink.cmp').setup({
  keymap = { preset = 'super-tab' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
  signature = { enabled = true },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
})

----------------------------------------------------------------------
-- fzf-lua
----------------------------------------------------------------------
require('fzf-lua').setup {
  winopts = {
    fullscreen = true,
    border = 'none',
    backdrop = 100,
    preview = {
      default = 'builtin',
      horizontal = 'right:50%',
      syntax_limit_b = 1024 * 100,
      border = 'none',
    },
  },
  diagnostics = { multiline = 1 },
}
vim.cmd [[ FzfLua register_ui_select ]]

vim.keymap.set('n', '<leader><space>', '<cmd>FzfLua files<cr>')
vim.keymap.set('n', '<leader>,', '<cmd>FzfLua buffers<cr>')
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep<cr>')
vim.keymap.set('n', '<leader>.', '<cmd>FzfLua lsp_workspace_diagnostics<cr>')
vim.keymap.set('n', 'gd', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'Go to declaration' })
vim.keymap.set('n', 'gi', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', '<cmd>FzfLua lsp_references<cr>', { desc = 'Go to references' })
vim.keymap.set('n', 'go', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'Go to type definition' })
vim.keymap.set('n', 'ga', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'Code actions' })
vim.keymap.set('n', '<leader>tk', '<cmd>FzfLua keymaps<cr>', { desc = 'Keymaps' })

----------------------------------------------------------------------
-- Flash
----------------------------------------------------------------------
require('flash').setup {
  modes = { search = { enabled = false } },
}

vim.keymap.set({ 'n', 'x', 'o' }, '<Enter>', function() require('flash').jump() end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })

----------------------------------------------------------------------
-- Aerial
----------------------------------------------------------------------
require('aerial').setup {
  on_attach = function(bufnr)
    vim.keymap.set('n', '_', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '+', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
}
vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = 'Toggle aerial' })

----------------------------------------------------------------------
-- Conform (formatting)
----------------------------------------------------------------------
require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format' },
    javascript = { { 'prettier' } },
    typescript = { { 'prettier' } },
    php = { 'php' },
  },
  formatters = {
    shfmt = { prepend_args = { '-i', '2' } },
    php = {
      command = 'php-cs-fixer',
      args = { 'fix', '$FILENAME' },
      stdin = false,
    },
  },
}
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.keymap.set('', '<leader>cf', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = 'Format buffer' })

----------------------------------------------------------------------
-- Lint
----------------------------------------------------------------------
require('lint').linters_by_ft = {
  dockerfile = { 'hadolint' },
}

vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
  callback = function()
    local ok, lint = pcall(require, 'lint')
    if ok then lint.try_lint() end
  end,
})

----------------------------------------------------------------------
-- Neogit
----------------------------------------------------------------------
require('neogit').setup {
  disable_hint = false,
  disable_context_highlighting = false,
  disable_signs = false,
  disable_insert_on_commit = 'auto',
}
vim.keymap.set('n', '<leader>tg', function() vim.cmd 'Neogit' end, { desc = 'Neogit' })

----------------------------------------------------------------------
-- Undotree
----------------------------------------------------------------------
vim.g.undotree_WindowLayout = 3
vim.g.undotree_SplitWidth = 50
vim.g.undotree_HelpLine = 0
vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle)

----------------------------------------------------------------------
-- Kulala (REST client)
----------------------------------------------------------------------
require('kulala').setup { global_keymaps = true }

----------------------------------------------------------------------
-- Peek (markdown preview)
----------------------------------------------------------------------
require('peek').setup()
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})

----------------------------------------------------------------------
-- Mini.nvim
----------------------------------------------------------------------
vim.keymap.set('n', '<c-e>', function()
  local MiniFiles = require 'mini.files'
  local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  vim.defer_fn(function() MiniFiles.reveal_cwd() end, 30)
end)

require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.bufremove').setup()
require('mini.bracketed').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('mini.notify').setup {
  window = { config = { border = 'none' } },
}

local hipatterns = require 'mini.hipatterns'
hipatterns.setup {
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

local miniicons = require 'mini.icons'
miniicons.setup { style = 'glyph' }
miniicons.mock_nvim_web_devicons()

require('mini.files').setup {
  content = {
    filter = function(entry)
      return entry.name ~= '.DS_Store' and entry.name ~= '.git'
        and entry.name ~= 'node_modules' and entry.name ~= '__pycache__'
    end,
  },
  mappings = {
    close = '<esc>',
    go_in = '<right>',
    go_in_plus = 'L',
    go_out = '<left>',
    go_out_plus = 'H',
    reset = '<BS>',
    reveal_cwd = '@',
    show_help = 'g?',
    synchronize = '=',
    trim_left = '<',
    trim_right = '>',
  },
  windows = {
    max_number = 3,
    preview = true,
    width_focus = 30,
    width_nofocus = 15,
    width_preview = 65,
  },
}
