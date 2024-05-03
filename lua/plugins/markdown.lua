return {
    {
        'kat0h/bufpreview.vim',
        lazy = true,
        ft = 'markdown',
        dependencies = { 'vim-denops/denops.vim' },
        build = 'deno task prepare'
    },
    {
        'mattn/vim-maketable',
        lazy = true,
        ft = 'markdown',
    },
    {
        'https://github.com/preservim/vim-markdown',
        require = { 'https://github.com/godlygeek/tabular' },
        lazy = true,
        ft = 'markdown',
        config = function()
            vim.g.vim_markdown_folding_level = 2
            vim.g.vim_markdown_frontmatter = 1
            -- vim.o.foldenable = false
            vim.g.vim_markdown_new_list_item_indent = 0
        end
    },
    {
        "https://github.com/epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        dependencies = {
            -- Required.
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
            'nvim-telescope/telescope.nvim',
            'nvim-treesitter/nvim-treesitter',
            -- see below for full list of optional dependencies 👇
        },
        opts = {
            -- Base dir of Obsidian vault
            workspaces = {
                {
                    name = "tkm",
                    path = "~/Dropbox/tkm",
                },
                {
                    name = "tkn",
                    path = "~/Dropbox/tkn",
                },
            },
            completion = {
                -- Set to false to disable completion.
                nvim_cmp = true,
                -- Trigger completion at 2 chars.
                min_chars = 2,
            },
            -- Either 'wiki' or 'markdown'.
            preferred_link_style = "markdown",

            -- Daily note settings.
            daily_notes = {
                -- Optional, if you keep daily notes in a separate directory.
                folder = "",
                -- Optional, if you want to change the date format for the ID of daily notes.
                date_format = "%Y-%m-%d",
                -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                template = nil
            },

            -- Template settings.
            templates = {
                subdir = ".config/template",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
                -- A map for custom variables, the key should be the variable and the value a function
                substitutions = {
                    yesterday = function()
                        return os.date("%Y-%m-%d", os.time() - 86400)
                    end,
                },
            },
            -- Optional, customize how note IDs are generated given an optional title.
            ---@param title string|?
            ---@return string
            note_id_func = function(title)
                -- Generate a unique ID YYYYMMDDHHMMSS format
                return tostring(os.date("%Y%m%d%H%M%S"))
            end,

            -- Optional, alternatively you can customize the frontmatter data.
            ---@return table
            note_frontmatter_func = function(note)
                -- Add the title of the note as an alias.
                if note.title then
                    note:add_alias(note.title)
                end

                -- Create timestamps for created and updated times
                local created_time = os.date("%Y-%m-%d %H:%M") -- ISO 8601 format
                local updated_time = created_time              -- Initially, created and updated times are the same

                -- Initialize the frontmatter table
                local out = {
                    id = note.id,
                    title = note.title,
                    aliases = note.aliases,
                    tags = note.tags,
                    created = created_time,
                    updated = updated_time
                }

                -- If note.metadata already has created or updated, use those values instead
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                    if note.metadata.created then out.created = note.metadata.created end
                    if note.metadata.updated then out.updated = note.metadata.updated end
                end

                return out
            end,

            -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
            -- URL it will be ignored but you can customize this behavior here.
            ---@param url string
            follow_url_func = function(url)
                -- Open the URL in the default web browser.
                vim.fn.jobstart({ "open", url }) -- Mac OS
                -- vim.fn.jobstart({"xdg-open", url})  -- linux
            end,

            vim.api.nvim_set_keymap('n', '<leader>on', '<cmd>ObsidianNew<cr>', { noremap = true, silent = true }),
            vim.api.nvim_set_keymap('n', '<leader>os', '<cmd>ObsidianFollowLink hsplit<cr>',
                { noremap = true, silent = true }),
            vim.api.nvim_set_keymap('n', '<leader>ot', '<cmd>ObsidianToday<cr>',
                { noremap = true, silent = true }),
            vim.api.nvim_set_keymap('n', '<leader>ob', '<cmd>ObsidianBacklinks<cr>',
                { noremap = true, silent = true }),
        },
        ui = {
            enable = true,
            checkboxes = {
                [" "] = { hl_group = "ObsidianTodo" },
                ["x"] = { hl_group = "ObsidianDone" },
                [">"] = { hl_group = "ObsidianRightArrow" },
            },
            bullets = { char = "-", hl_group = "ObsidianBullet" },
        },
    },
}
