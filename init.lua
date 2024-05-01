-- Basic
-- encoding
vim.o.encofing = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.o.ambiwidth = 'double'
vim.o.conceallevel = 0
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.visualbell = true
vim.o.showmatch = true
vim.o.matchtime = 1
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.opt.clipboard:append { 'unnamedplus' }
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('cache') .. '/undo'
vim.o.foldlevel = 1
vim.o.autochdir = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- remap
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', 's', '', { noremap = true })
vim.g.maplocalleader = 's'
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })
vim.api.nvim_set_keymap('n', 'gj', 'j', { noremap = true })
vim.api.nvim_set_keymap('n', 'gk', 'k', { noremap = true })
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true })
vim.api.nvim_set_keymap('n', ':', ';', { noremap = true })
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohl<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w>t', ':tabnew<CR>', { noremap = true, silent = true })

-- plugin

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- code highlight
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- Tree-sitterの設定
            require 'nvim-treesitter.configs'.setup {
                highlight = {
                    ensure_installed = { "markdown" },
                    enable = true, -- Tree-sitterハイライトを有効化
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    },
    -- colorscheme
    {
        'navarasu/onedark.nvim',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('onedark').setup {
                style = 'warm'
            }
            require('onedark').load()
        end,
    },
    -- launcher
    {
        'nvim-telescope/telescope.nvim',
        -- tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        'kat0h/bufpreview.vim',
        dependencies = { 'vim-denops/denops.vim' },
        build = 'deno task prepare'
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 1000
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        config = function()
            local wk = require("which-key")
            wk.register({
                ["<leader>"] = {
                    name = "Telescope",
                    [";"] = { "<cmd>lua require('telescope.builtin').command_history()<cr>", "Command history" },
                    f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find Files" },
                    g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
                    b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
                    h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help Tags" },
                    u = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Recent Files" },
                }
            })
        end
    },
    {
        'adelarsq/image_preview.nvim',
        event = 'VeryLazy',
        config = function()
            require("image_preview").setup()
            vim.api.nvim_set_keymap('n', '<leader>p',
                '<cmd>lua require("image_preview").PreviewImage(vim.fn.getcwd() .. "/" .. vim.fn.expand("<cfile>"))<cr>',
                { noremap = true, silent = true })
        end
    },
    {
        -- neotree
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    window = {
                        mappings = {
                            ["<leader>p"] = "image_wezterm", -- " or another map
                        },
                    },
                    commands = {
                        image_wezterm = function(state)
                            local node = state.tree:get_node()
                            if node.type == "file" then
                                require("image_preview").PreviewImage(node.path)
                            end
                        end,
                    },
                },
                vim.api.nvim_set_keymap('n', '-', '<cmd>Neotree toggle<cr>',
                    { noremap = true, silent = true })
            })
        end
    },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require 'cmp'
            cmp.setup {
                sources = {
                    { name = "neorg" },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
            }
        end
    },
    {
        'mattn/vim-maketable',
    },
    {
        'anuvyklack/pretty-fold.nvim',
        config = function()
            require('pretty-fold').setup()
        end
    },
    {
        'plasticboy/vim-markdown',
        require = { 'godlygeek/tabular' },
        lazy = true,
        ft = 'markdown',
        config = function()
            vim.g.vim_markdown_folding_level = 2
            vim.g.vim_markdown_frontmatter = 1
            vim.o.foldenable = false
            vim.g.vim_markdown_new_list_item_indent = 0
        end
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        dependencies = {
            -- Required.
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
            'nvim-telescope/telescope.nvim',
            'nvim-treesitter/nvim-treesitter',
            -- see below for full list of optional dependencies 👇
        },
        opts = {
            -- Base dir of Obsidian vault
            workspaces = {
                {
                    name = "tkm",
                    path = "~/Dropbox/tkm",
                },
            },
            completion = {
                -- Set to false to disable completion.
                nvim_cmp = true,
                -- Trigger completion at 2 chars.
                min_chars = 2,
            },
            -- Either 'wiki' or 'markdown'.
            preferred_link_style = "markdown",

            -- Daily note settings.
            daily_notes = {
                -- Optional, if you keep daily notes in a separate directory.
                folder = "",
                -- Optional, if you want to change the date format for the ID of daily notes.
                date_format = "%Y-%m-%d",
                -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                template = nil
            },

            -- Template settings.
            templates = {
                subdir = ".config/template",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
                -- A map for custom variables, the key should be the variable and the value a function
                substitutions = {
                    yesterday = function()
                        return os.date("%Y-%m-%d", os.time() - 86400)
                    end,
                },
            },
            -- Optional, customize how note IDs are generated given an optional title.
            ---@param title string|?
            ---@return string
            note_id_func = function(title)
                -- Generate a unique ID YYYYMMDDHHMMSS format
                return tostring(os.date("%Y%m%d%H%M%S"))
            end,

            -- Optional, alternatively you can customize the frontmatter data.
            ---@return table
            note_frontmatter_func = function(note)
                -- Add the title of the note as an alias.
                if note.title then
                    note:add_alias(note.title)
                end

                -- Create timestamps for created and updated times
                local created_time = os.date("%Y-%m-%d %H:%M") -- ISO 8601 format
                local updated_time = created_time              -- Initially, created and updated times are the same

                -- Initialize the frontmatter table
                local out = {
                    id = note.id,
                    title = note.title,
                    aliases = note.aliases,
                    tags = note.tags,
                    created = created_time,
                    updated = updated_time
                }

                -- If note.metadata already has created or updated, use those values instead
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                    if note.metadata.created then out.created = note.metadata.created end
                    if note.metadata.updated then out.updated = note.metadata.updated end
                end

                return out
            end,
            vim.api.nvim_set_keymap('n', '<leader>on', '<cmd>ObsidianNew<cr>', { noremap = true, silent = true }),
            vim.api.nvim_set_keymap('n', '<leader>os', '<cmd>ObsidianFollowLink hsplit<cr>',
                { noremap = true, silent = true }),
            vim.api.nvim_set_keymap('n', '<leader>ot', '<cmd>ObsidianToday<cr>',
                { noremap = true, silent = true }),
            vim.api.nvim_set_keymap('n', '<leader>ob', '<cmd>ObsidianBacklinks<cr>',
                { noremap = true, silent = true }),
        },
        ui = {
            enable = true,
            bullets = { hl_group = "ObsidianBullet" },
            checkboxes = {
                [" "] = { hl_group = "ObsidianTodo" },
                ["x"] = { hl_group = "ObsidianDone" },
                ["s"] = { hl_group = "ObsidianDone" },
                [">"] = { hl_group = "ObsidianRightArrow" },
                ["k"] = { hl_group = "ObsidianRightArrow" },
                ["m"] = { hl_group = "ObsidianRightArrow" },
                ["~"] = { hl_group = "ObsidianTilde" },
                ["t"] = { hl_group = "ObsidianTilde" },
            },
        },
    },
})

-- Markdown ファイルに対するオリジナルハイライト設定
vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufEnter" }, {
    pattern = "markdown",
    callback = function()
        -- ハイライトルールを再設定
        vim.api.nvim_set_hl(0, 'TodoHighlight', { fg = '#B80000', bg = '#ffffff', bold = true })
        vim.api.nvim_set_hl(0, 'DoneHighlight', { fg = '#00B800', bg = '#ffffff', bold = true })
        vim.api.nvim_set_hl(0, 'ScheduleHighlight', { fg = '#00B800', bold = true })
        vim.api.nvim_set_hl(0, 'DeadlineHighlight', { fg = '#E80000', bold = true })

        -- パターンマッチングで`TODO`と`DONE`をハイライト（正規表現のチェック）
        vim.fn.matchadd('TodoHighlight', '\\v(#+\\s+)@<=TODO', 100)
        vim.fn.matchadd('DoneHighlight', '\\v(#+\\s+)@<=DONE', 100)
        vim.fn.matchadd('ScheduleHighlight', 'Schedule:', 100)
        vim.fn.matchadd('DeadlineHighlight', 'Deadline:', 100)
    end
})

function SearchTodoInMarkdownFiles()
    local path = vim.fn.getcwd()
    local todo_buf = vim.fn.bufnr('__TODO__')

    -- 既に__TODO__バッファがある場合は、そのバッファを削除して再作成
    if todo_buf ~= -1 and vim.api.nvim_buf_is_loaded(todo_buf) then
        -- バッファが開いているウィンドウを取得
        local windows = vim.api.nvim_list_wins()
        for _, window in ipairs(windows) do
            if vim.api.nvim_win_get_buf(window) == todo_buf then
                vim.api.nvim_win_close(window, true)
            end
        end
        vim.api.nvim_buf_delete(todo_buf, { force = true })
    end

    -- 新しいバッファを作成
    todo_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(todo_buf, '__TODO__')

    -- ディレクトリを再帰的にスキャンして.mdファイルを検索
    local function scan_dir(dir)
        local todos = {}
        local handle, err = vim.loop.fs_scandir(dir)
        if handle then
            while true do
                local name, type = vim.loop.fs_scandir_next(handle)
                if not name then break end
                local full_path = dir .. '/' .. name
                if type == 'directory' then
                    vim.list_extend(todos, scan_dir(full_path))
                elseif type == 'file' and name:match('%.md$') then
                    local file = io.open(full_path, "r")
                    if file then
                        local lines = file:lines()
                        local line_number = 1
                        local todo_line = nil
                        local todo_line_number = nil
                        for line in lines do
                            if line:find('^#+ TODO ') then
                                todo_line = line
                                todo_line_number = line_number
                                local formatted_todo_info = string.format('%s:%d', full_path, todo_line_number)
                                -- @s:xxxx-xx-xxの形式の部分を抽出してscheduleに格納する
                                local schedule = todo_line:match("@s:(%d%d%d%d%-%d%d%-%d%d)")
                                -- @d:xxxx-xx-xxの形式の部分を抽出してdeadlineに格納する
                                local deadline = todo_line:match("@d:(%d%d%d%d%-%d%d%-%d%d)")

                                local formatted_todo = string.format('%s',
                                    todo_line:gsub("@s:%d%d%d%d%-%d%d%-%d%d @d:%d%d%d%d%-%d%d%-%d%d", ""))

                                if schedule == nil then
                                    schedule = "None"
                                end
                                if deadline == nil then
                                    deadline = "None"
                                end
                                local formatted_date = string.format('Schedule: %s | Deadline: %s', schedule, deadline)
                                table.insert(todos, formatted_todo_info)
                                table.insert(todos, formatted_todo)
                                if deadline == "None" and schedule == "None" then
                                else
                                    table.insert(todos, formatted_date)
                                end
                                table.insert(todos, "")
                                todo_line = nil -- Reset the TODO line tracker
                            else
                                todo_line = nil
                            end
                            line_number = line_number + 1
                        end
                        file:close()
                    end
                end
            end
        elseif err then
            vim.api.nvim_err_writeln('Error opening directory ' .. dir .. ': ' .. err)
        end
        return todos
    end

    local todos = scan_dir(path)

    if #todos > 0 then
        vim.api.nvim_buf_set_option(todo_buf, 'modifiable', true)
        vim.api.nvim_buf_set_lines(todo_buf, 0, -1, false, todos)
        vim.api.nvim_buf_set_option(todo_buf, 'modifiable', false)
        vim.api.nvim_command('split')
        vim.api.nvim_win_set_buf(0, todo_buf)
        -- vim.api.nvim_buf_set_option(todo_buf, 'filetype', 'markdown')
    else
        print('No TODOs found.')
    end
end

vim.api.nvim_command('command! -nargs=0 TodoSearchInMarkdown lua SearchTodoInMarkdownFiles()')

require('markdown_title_picker')
vim.api.nvim_set_keymap('n', '<leader>oo', "<cmd>lua require('markdown_title_picker').open_markdown_by_title()<CR>",
    { noremap = true, silent = true })
