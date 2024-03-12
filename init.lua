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
vim.opt.clipboard:append{'unnamedplus'}
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('cache') .. '/undo'

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- remap
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", {noremap = true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.api.nvim_set_keymap('n', ':', ';', {noremap = true})
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true})
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})
vim.api.nvim_set_keymap('n', 'gj', 'j', {noremap = true})
vim.api.nvim_set_keymap('n', 'gk', 'k', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<Enter><Enter>', ':<C-u>w<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohl<CR>', { noremap = true, silent = true})

-- load lazy.nvim
require('lazy_nvim')
require('inserttime')

