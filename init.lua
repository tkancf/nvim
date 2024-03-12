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
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader><leader>f', builtin.find_files, {})
            vim.keymap.set('n', '<leader><leader>g', builtin.live_grep, {})
            vim.keymap.set('n', '<leader><leader>b', builtin.buffers, {})
            vim.keymap.set('n', '<leader><leader>h', builtin.help_tags, {})
        end
    }
})
