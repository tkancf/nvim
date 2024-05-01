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
    -- fold text
    {
        'anuvyklack/pretty-fold.nvim',
        config = function()
            require('pretty-fold').setup()
        end
    },
    {
        'cohama/lexima.vim'
    },
}
