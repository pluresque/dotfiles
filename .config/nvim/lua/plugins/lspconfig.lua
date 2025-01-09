return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    dependencies = { 'saghen/blink.cmp' },
    opts = {
      servers = {
        pyright = {},
        ruff = {},
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              check = {
                command = 'clippy',
              },
              diagnostics = {
                enable = true,
              },
            },
          },
        },
        omnisharp = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                kubernetes = 'k8s-*.yaml',
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
                ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
                ['https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json'] = 'argocd-application.yaml',
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

      require('mason').setup {}
      require('mason-lspconfig').setup()

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
    end,
  },
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim' },
    },
  },
}
