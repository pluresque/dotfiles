return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    dependencies = { 'saghen/blink.cmp' },
    opts = {
      servers = {
        basedpyright = {},
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
      local lsp_config = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      for lsp, config in pairs(opts.servers) do
        local setup_function = lsp_config[lsp] and lsp_config[lsp].setup
        if setup_function then
          config.capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
          setup_function(config)
        else
          print('LSP setup function not found for:', lsp)
        end
      end

      local function organize_imports()
        local params = {
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = '',
        }
        vim.lsp.buf.execute_command(params)
      end

      lsp_config.ts_ls.setup {
        capabilities = capabilities,
        commands = {
          OrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
          },
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
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

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = event.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end,
      })
    end,
  },
}
