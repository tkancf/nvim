return {
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
}
