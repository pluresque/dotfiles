return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  enabled = false,
  -- use a release tagy to download pre-built binaries
  version = 'v0.*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- On musl libc based systems you need to add this flag
  -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',

  opts = {
    -- keymap = {
    --   show = '<C-space>',
    --   hide = '<C-e>',
    --   accept = '<Right>',
    --   select_prev = { '<Up>' },
    --   select_next = { '<Down>' },
    --
    --   show_documentation = '<C-space>',
    --   hide_documentation = '<C-space>',
    --   scroll_documentation_up = '<C-b>',
    --   scroll_documentation_down = '<C-f>',
    --
    --   snippet_forward = {},
    --   snippet_backward = {},
    -- },

    -- highlight = {
    --   -- sets the fallback highlight groups to nvim-cmp's highlight groups
    --   -- useful for when your theme doesn't support blink.cmp
    --   -- will be removed in a future release, assuming themes add support
    --   use_nvim_cmp_as_default = true,
    -- },
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    -- nerd_font_variant = 'mono'

    -- experimental auto-brackets support
    -- accept = { auto_brackets = { enabled = true } }

    -- kind_icons = {
    --   Text = 'txt',
    --   Method = 'method',
    --   Function = 'func',
    --   Constructor = 'construct',
    --   Field = 'field',
    --   Variable = 'var',
    --   Property = 'prop',
    --   Class = 'class',
    --   Interface = 'interface',
    --   Struct = 'struct',
    --   Module = 'mod',
    --   Unit = 'unit',
    --   Value = 'value',
    --   Enum = 'enum',
    --   EnumMember = 'enummember',
    --   Keyword = 'keyword',
    --   Constant = 'const',
    --   Snippet = 'snippet',
    --   Color = 'color',
    --   File = 'file',
    --   Reference = 'ref',
    --   Folder = 'dir',
    --   Event = 'event',
    --   Operator = 'operator',
    --   TypeParameter = 'typeparameter',
    -- },
  },
}
