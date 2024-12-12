vim.loader.enable()

require 'config.options'  -- General Options
require 'config.lazy'     -- Package Manager
require 'config.autocmds' -- Autocommands
require 'config.keymaps'  -- Keymaps

require 'lib.sessions'    -- Session Manager
require 'lib.statusline'
