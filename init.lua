-- Basic
-- encoding
vim.o.encofing = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.o.ambiwidth = 'double'
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
vim.g.maplocalleader = ','
vim.api.nvim_set_keymap('n', 's', '', { noremap = true })
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
    -- todo.txt
    { "freitass/todo.txt-vim" },
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
        config = function()
            local builtin = require('telescope.builtin')
            -- vim.keymap.set('n', '<leader><leader>f', builtin.find_files, {})
            -- vim.keymap.set('n', '<leader><leader>g', builtin.live_grep, {})
            -- vim.keymap.set('n', '<leader><leader>b', builtin.buffers, {})
            -- vim.keymap.set('n', '<leader><leader>h', builtin.help_tags, {})
        end
    },
    -- zettelkasten
    {
        'renerocksai/telekasten.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            -- home = vim.fn.expand("~/memo")
            require('telekasten').setup({
                home = vim.fn.expand("~/memo"), -- Put the name of your notes directory here
            })
        end
    },
    -- markdown preview
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
                    ["<leader>"] = {
                        name = "telescope",
                        f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find Files" },
                        g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
                        b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
                        h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help Tags" },
                        u = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Recent Files" },
                    },
                    -- telekasten
                    t = {
                        name = "telekasten",
                        p = { "<cmd>lua require('telekasten').panel()<cr>", "Telekasten panel" },
                        f = { "<cmd>lua require('telekasten').find_notes()<cr>", "Telekasten find_notes" },
                        g = { "<cmd>lua require('telekasten').search_notes()<cr>", "Telekasten search_notes" },
                        d = { "<cmd>lua require('telekasten').goto_today()<cr>", "Telekasten goto_today" },
                        t = { "<cmd>lua require('telekasten').follow_link()<cr>", "Telekasten follow_link" },
                        n = { "<cmd>lua require('telekasten').new_note()<cr>", "Telekasten new_note" },
                        c = { "<cmd>lua require('telekasten').show_calendar()<cr>", "Telekasten show_calendar" },
                        b = { "<cmd>lua require('telekasten').show_backlinks()<cr>", "Telekasten show_backlinks" },
                        I = { "<cmd>lua require('telekasten').insert_img_link()<cr>", "Telekasten insert_img_link" },
                        i = { "<cmd>lua require('telekasten').insert_link()<cr>", "Telekasten insert_link" },
                    },
                }
            })
        end

    }
})
