-- Basic
-- encoding
vim.o.encofing = 'utf-8'
vim.scriptencoding = 'utf-8'
-- vim.o.ambiwidth = 'double'
vim.o.conceallevel = 2
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
                    ensure_installed = { "markdown", "markdown_inline" },
                    enable = true, -- Tree-sitterハイライトを有効化
                    additional_vim_regex_highlighting = true,
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
            vim.o.timeoutlen = 300
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
                    name = "telescope",
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
                '<cmd>lua require("image_preview").PreviewImage(vim.fn.expand("<cfile>"))<cr>',
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
        'masukomi/vim-markdown-folding',
    },
    {
        'anuvyklack/pretty-fold.nvim',
        config = function()
            require('pretty-fold').setup()
        end
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        --   "BufReadPre path/to/my-vault/**.md",
        --   "BufNewFile path/to/my-vault/**.md",
        -- },
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
                folder = "01_daily",
                -- Optional, if you want to change the date format for the ID of daily notes.
                date_format = "%Y-%m-%d",
                -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                template = nil
            },

            -- Template settings.
            templates = {
                subdir = "99_template",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
                -- A map for custom variables, the key should be the variable and the value a function
                substitutions = {
                    yesterday = function()
                        return os.date("%Y-%m-%d", os.time() - 86400)
                    end,
                },
            },
        },
    },
})
