return {
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<c-e>',
        function()
          local MiniFiles = require 'mini.files'
          local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          vim.defer_fn(function()
            MiniFiles.reveal_cwd()
          end, 30)
        end,
      },
    },
    config = function()
      -- Better Around/Inside textobjects
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
      require('mini.bufremove').setup()
      require('mini.bracketed').setup()
      require('mini.diff').setup()
      require('mini.git').setup()

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

      -- File explorer
      require('mini.files').setup {
        content = {
          filter = function(entry)
            return entry.name ~= '.DS_Store' and entry.name ~= '.git' and entry.name ~= 'node_modules'
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

      local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
      local autocmd = vim.api.nvim_create_autocmd
      local _, MiniFiles = pcall(require, "mini.files")

      local gitStatusCache = {}
      local cacheTimeout = 2000

      ---@type table<string, {symbol: string, hlGroup: string}>
      ---@param status string
      ---@return string symbol, string hlGroup
      local function mapSymbols(status)
        local statusMap = {
          -- stylua: ignore start
          [" M"] = { symbol = "M", hlGroup = "GitSignsChange" }, -- Modified in the working directory
          ["M "] = { symbol = "M", hlGroup = "GitSignsChange" }, -- modified in index
          ["MM"] = { symbol = "≠", hlGroup = "GitSignsChange" }, -- modified in both working tree and index
          ["A "] = { symbol = "A", hlGroup = "GitSignsAdd" }, -- Added to the staging area, new file
          ["AA"] = { symbol = "A", hlGroup = "GitSignsAdd" }, -- file is added in both working tree and index
          ["D "] = { symbol = "D", hlGroup = "GitSignsDelete" }, -- Deleted from the staging area
          ["AM"] = { symbol = "⊕", hlGroup = "GitSignsChange" }, -- added in working tree, modified in index
          ["AD"] = { symbol = "-•", hlGroup = "GitSignsChange" }, -- Added in the index and deleted in the working directory
          ["R "] = { symbol = "R", hlGroup = "GitSignsChange" }, -- Renamed in the index
          ["U "] = { symbol = "‖", hlGroup = "GitSignsChange" }, -- Unmerged path
          ["UU"] = { symbol = "⇄", hlGroup = "GitSignsAdd" }, -- file is unmerged
          ["UA"] = { symbol = "⊕", hlGroup = "GitSignsAdd" }, -- file is unmerged and added in working tree
          ["??"] = { symbol = "?", hlGroup = "GitSignsDelete" }, -- Untracked files
          ["!!"] = { symbol = "!", hlGroup = "GitSignsChange" }, -- Ignored files
        }

        local result = statusMap[status]
            or { symbol = "?", hlGroup = "NonText" }
        return result.symbol, result.hlGroup
      end

      ---@param cwd string
      ---@param callback function
      ---@return nil
      local function fetchGitStatus(cwd, callback)
        local function on_exit(content)
          if content.code == 0 then
            callback(content.stdout)
            vim.g.content = content.stdout
          end
        end
        vim.system(
          { "git", "status", "--ignored", "--porcelain" },
          { text = true, cwd = cwd },
          on_exit
        )
      end

      local function escapePattern(str)
        return str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
      end

      local function updateMiniWithGit(buf_id, gitStatusMap)
        vim.schedule(function()
          local nlines = vim.api.nvim_buf_line_count(buf_id)
          local cwd = vim.fs.root(buf_id, ".git")
          local escapedcwd = escapePattern(cwd)
          if vim.fn.has("win32") == 1 then
            escapedcwd = escapedcwd:gsub("\\", "/")
          end

          for i = 1, nlines do
            local entry = MiniFiles.get_fs_entry(buf_id, i)
            if not entry then
              break
            end
            local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
            local status = gitStatusMap[relativePath]

            if status then
              local symbol, hlGroup = mapSymbols(status)
              vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
                -- NOTE: if you want the signs on the right uncomment those and comment
                -- the 3 lines after
                -- virt_text = { { symbol, hlGroup } },
                -- virt_text_pos = "right_align",
                sign_text = symbol,
                sign_hl_group = hlGroup,
                priority = 2,
              })
            else
            end
          end
        end)
      end


      -- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
      ---@param content string
      ---@return table
      local function parseGitStatus(content)
        local gitStatusMap = {}
        -- lua match is faster than vim.split (in my experience )
        for line in content:gmatch("[^\r\n]+") do
          local status, filePath = string.match(line, "^(..)%s+(.*)")
          -- Split the file path into parts
          local parts = {}
          for part in filePath:gmatch("[^/]+") do
            table.insert(parts, part)
          end
          -- Start with the root directory
          local currentKey = ""
          for i, part in ipairs(parts) do
            if i > 1 then
              -- Concatenate parts with a separator to create a unique key
              currentKey = currentKey .. "/" .. part
            else
              currentKey = part
            end
            -- If it's the last part, it's a file, so add it with its status
            if i == #parts then
              gitStatusMap[currentKey] = status
            else
              -- If it's not the last part, it's a directory. Check if it exists, if not, add it.
              if not gitStatusMap[currentKey] then
                gitStatusMap[currentKey] = status
              end
            end
          end
        end
        return gitStatusMap
      end

      local function updateGitStatus(buf_id)
        if not vim.fs.root(vim.uv.cwd(), ".git") then
          return
        end

        local cwd = vim.fn.expand("%:p:h")
        local currentTime = os.time()
        if
            gitStatusCache[cwd]
            and currentTime - gitStatusCache[cwd].time < cacheTimeout
        then
          updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
        else
          fetchGitStatus(cwd, function(content)
            local gitStatusMap = parseGitStatus(content)
            gitStatusCache[cwd] = {
              time = currentTime,
              statusMap = gitStatusMap,
            }
            updateMiniWithGit(buf_id, gitStatusMap)
          end)
        end
      end

      ---@return nil
      local function clearCache()
        gitStatusCache = {}
      end

      local function augroup(name)
        return vim.api.nvim_create_augroup(
          "MiniFiles_" .. name,
          { clear = true }
        )
      end

      autocmd("User", {
        group = augroup("start"),
        pattern = "MiniFilesExplorerOpen",
        -- pattern = { "minifiles" },
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          updateGitStatus(bufnr)
        end,
      })

      autocmd("User", {
        group = augroup("close"),
        pattern = "MiniFilesExplorerClose",
        callback = function()
          clearCache()
        end,
      })

      autocmd("User", {
        group = augroup("update"),
        pattern = "MiniFilesBufferUpdate",
        callback = function(sii)
          local bufnr = sii.data.buf_id
          local cwd = vim.fn.expand("%:p:h")
          if gitStatusCache[cwd] then
            updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
          end
        end,
      })
    end,
  },
}
