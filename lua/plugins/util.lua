return {
    -- image preview
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
    }
}
