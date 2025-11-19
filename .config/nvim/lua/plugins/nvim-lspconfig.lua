return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    dependencies = { 'saghen/blink.cmp' },
    opts = {
      servers = {
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
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Setup all servers using vim.lsp.config()
      for server_name, config in pairs(opts.servers) do
        config.capabilities = capabilities
        vim.lsp.config(server_name, config)
      end

      -- Setup TypeScript with organize imports command
      local function organize_imports()
        local params = {
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
        vim.lsp.buf_request(0, 'workspace/executeCommand', params)
      end

      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        commands = {
          OrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
          },
        },
      })

      -- Enable servers for current buffer when appropriate
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('lsp-enable', { clear = true }),
        callback = function()
          -- Enable all configured servers
          for server_name, _ in pairs(opts.servers) do
            vim.lsp.enable(server_name)
          end
          -- Also enable ts_ls
          vim.lsp.enable('ts_ls')
        end,
      })

      -- LspAttach autocmd for keymaps and features
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- Document highlight
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd('CursorHold', {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd('CursorHoldI', {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd('CursorMoved', {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('CursorMovedI', {
              buffer = event.buf,
              group = highlight_augroup,
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
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- Code lens
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd("BufEnter", {
              buffer = event.buf,
              callback = vim.lsp.codelens.refresh,
            })
            vim.api.nvim_create_autocmd("CursorHold", {
              buffer = event.buf,
              callback = vim.lsp.codelens.refresh,
            })
            vim.api.nvim_create_autocmd("InsertLeave", {
              buffer = event.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end,
      })
    end,
  },
}
