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
        build = ":TSUpdate"
    },
    -- colorscheme
    {
        "olimorris/onedarkpro.nvim",
        name = "onedark",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd([[colorscheme onedark]])
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
            local _, neorg = pcall(require, "neorg.core")
            local dirman = neorg.modules.get_module("core.dirman")
            local function get_todos(dir, states)
                local current_workspace = dirman.get_current_workspace()
                local dir = current_workspace[2]
                local pattern = "-"
                -- Add vimgrep_arguments to exclude template.norg files
                require('telescope.builtin').live_grep {
                    cwd = dir,
                    vimgrep_arguments = {
                        'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case',
                        '-g', '!template.norg',
                    }
                }
                vim.fn.feedkeys('^ *([*]+|[-]+) +[(]' .. states .. '[)]')
            end

            -- This can be bound to a key
            -- vim.keymap.set('n', '<leader>ot', function() get_todos('~/notes', '[^x_]') end)
            vim.api.nvim_create_user_command('GetTodos', function()
                get_todos('~/notes', '[^x_]')
            end, {})
            wk.register({
                ["<leader>"] = {
                    ["<leader>"] = {
                        name = "telescope",
                        f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find Files" },
                        g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
                        b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
                        h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help Tags" },
                        u = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Recent Files" },
                    },
                    o = {
                        name = "neorg",
                        -- Neorg index
                        n = { "<cmd>Neorg index<cr>", "Neorg Index" },
                        m = {
                            name = "neorg mode",
                            -- These are the default actions for Neorg that you can use with the keymap
                            n = { "<cmd>Neorg mode norg<cr>", "norg mode" },
                            h = { "<cmd>Neorg mode traverse-heading<cr>", "traverse-heading mode" },
                            l = { "<cmd>Neorg mode traverse-link<cr>", "traverse-link mode" },
                        },
                        i = { "<cmd>Neorg toc<cr>", "Neorg TOC" },
                        -- vim.keymap.set('n', '<leader>ot', function() get_todos('~/notes', '[^x_]') end)
                        t = { "<cmd>GetTodos<cr>", "Neorg TODOs" },
                    },
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
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
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
                    -- { name = "orgmode" },
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
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        lazy = false, -- specify lazy = false because some lazy.nvim distributions set lazy = true by default
        -- tag = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            dir =
            "~/src/tkancf-neorg-module/",
        },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},  -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.dirman"] = {      -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                    ["core.journal"] = {
                        -- strategy: "flat" (2022-03-02.norg), "nested" (2022/03/02.norg)
                        config = {
                            strategy = "flat",
                        },
                    },
                    ["core.summary"] = {
                        config = {
                            strategy = "by_path",
                        },
                    },
                    ["core.export"] = {
                        config = {
                            export_dir = "export",
                        },
                    },
                    ["core.export.markdown"] = {
                        config = {
                            extensions = "all",
                        },
                    },
                },
            }
        end,
    },
})

require('clock')
