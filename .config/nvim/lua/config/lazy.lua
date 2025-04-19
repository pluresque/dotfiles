local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  change_detection = { enabled = false, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'gzip', -- edit compressed files
        'zipPlugin', -- edit compressed files
        'tarPlugin',
        'zip',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'tar',
        'rrhelper',
        'spellfile_plugin',
        'spellfile',
        'vimball',
        'vimballPlugin',
        'tutor',
        'rplugin',
        'optwin',
        -- 'compiler',
        'bugreport',
        'osc52',
        'man',
        'shada',
      },
    },
  },
})
