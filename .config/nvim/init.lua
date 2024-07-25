vim.loader.enable()

require 'config.options'  -- General Options
require 'config.lazy'     -- Package Manager 
require 'config.autocmds' -- Autocommands
require 'config.keymaps'  -- Keymaps

-- Custom Plugins
require 'lib.sessions'    -- Session Manager
require 'lib.statusline'  -- Statusline 
