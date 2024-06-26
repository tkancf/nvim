return {
    -- image preview
    {
        'https://github.com/adelarsq/image_preview.nvim',
        event = 'VeryLazy',
        config = function()
            require("image_preview").setup()
            vim.api.nvim_set_keymap('n', '<leader>p',
                '<cmd>lua require("image_preview").PreviewImage(vim.fn.getcwd() .. "/" .. vim.fn.expand("<cfile>"))<cr>',
                { noremap = true, silent = true })
        end
    },
    {
        'https://github.com/cohama/lexima.vim',
        config = function()
            vim.g.lexima_enable_space_rules = 0
        end,
    },
    {
        'https://github.com/rbtnn/vim-ambiwidth'
    },
    {
        'https://github.com/thinca/vim-qfreplace'
    },
    {
        'https://github.com/yuki-yano/lexima-alter-command.vim',
        dependencies = {
            'https://github.com/cohama/lexima.vim'
        },
        config = function()
            vim.cmd [[
                LeximaAlterCommand obw ObsidianWorkspace
                LeximaAlterCommand obd ObsidianDailies
                LeximaAlterCommand obt ObsidianToday
                LeximaAlterCommand obe ObsidianExtractNote
            ]]
        end,
    },
    {
        'https://github.com/machakann/vim-sandwich',
    },
    {
        'https://github.com/lambdalisue/gin.vim',
        dependencies = {
            'https://github.com/vim-denops/denops.vim',
        },
    },
    {
        'https://github.com/monaqa/dial.nvim',
        config = function()
            vim.keymap.set("n", "<C-a>", function()
                require("dial.map").manipulate("increment", "normal")
            end)
            vim.keymap.set("n", "<C-x>", function()
                require("dial.map").manipulate("decrement", "normal")
            end)
            vim.keymap.set("n", "g<C-a>", function()
                require("dial.map").manipulate("increment", "gnormal")
            end)
            vim.keymap.set("n", "g<C-x>", function()
                require("dial.map").manipulate("decrement", "gnormal")
            end)
            vim.keymap.set("v", "<C-a>", function()
                require("dial.map").manipulate("increment", "visual")
            end)
            vim.keymap.set("v", "<C-x>", function()
                require("dial.map").manipulate("decrement", "visual")
            end)
            vim.keymap.set("v", "g<C-a>", function()
                require("dial.map").manipulate("increment", "gvisual")
            end)
            vim.keymap.set("v", "g<C-x>", function()
                require("dial.map").manipulate("decrement", "gvisual")
            end)
        end,
    },
    {
        'https://github.com/haya14busa/vim-asterisk',
        config = function()
            local opts = { noremap = true, silent = true }

            vim.api.nvim_set_keymap('', '*', '<Plug>(asterisk-z*)', opts)
            vim.api.nvim_set_keymap('', '#', '<Plug>(asterisk-z#)', opts)
            vim.api.nvim_set_keymap('', 'g*', '<Plug>(asterisk-gz*)', opts)
            vim.api.nvim_set_keymap('', 'g#', '<Plug>(asterisk-gz#)', opts)
        end
    },
    {
        'https://github.com/tani/dmacro.nvim',
        config = function()
            require('dmacro').setup({
                dmacro_key = '<C-t>'
            })
        end
    },
}
