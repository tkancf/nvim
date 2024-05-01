return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        -- Tree-sitterの設定
        require 'nvim-treesitter.configs'.setup {
            highlight = {
                ensure_installed = { "markdown" },
                enable = true, -- Tree-sitterハイライトを有効化
                additional_vim_regex_highlighting = false,
            },
        }
    end,
}
