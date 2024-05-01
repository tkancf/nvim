return {
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
}
