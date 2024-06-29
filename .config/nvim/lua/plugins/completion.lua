return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    opts = function()
      local cmp = require 'cmp'
      local utils = require 'utils'
      return {
        mapping = cmp.mapping.preset.insert {
          ['<Tab>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ['<S-Tab>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ['<C-b>'] = cmp.mapping.scroll_docs(-1),
          ['<C-f>'] = cmp.mapping.scroll_docs(1),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        },
        sources = cmp.config.sources {
          {
            name = 'nvim_lsp',
            entry_filter = function(entry, ctx)
              local kind = cmp.lsp.CompletionItemKind[entry:get_kind()]
              if kind == 'Text' then
                return false
              end
              return true
            end,
          },
          { name = 'path' },
          -- { name = 'buffer' },
          -- { name = 'luasnip' },
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(_, item)
            item.kind = (utils.lsp_icons[item.kind] or ' ') .. item.kind .. ' '
            item.menu = '  '
            return item
          end,
        },
      }
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      -- 'saadparwaiz1/cmp_luasnip',
    },
  },
}
