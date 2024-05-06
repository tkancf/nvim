-- 必要なモジュールをインポート
local Path = require('plenary.path')
local scan = require('plenary.scandir')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- モジュールテーブルを作成
local M = {}

-- ディレクトリ内の Markdown ファイルからタイトルを抽出する
local function extract_titles(dir)
    local titles = {}
    local files = scan.scan_dir(dir, { hidden = false, add_dirs = false, depth = 1 })

    for _, file in ipairs(files) do
        local path = Path:new(file)
        local data = path:read()

        -- ファイルパスからファイル名のみを抽出
        local filename = file:match("([^/\\]+)$")

        -- Vim の正規表現を使って日付形式のファイル名を除外
        if vim.fn.match(filename, "\\v^(0[0-9]{3}|[1-9][0-9]{3})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])\\.md$") == -1 then
            local title = data:match("title: ([^\n]+)")
            if title then
                table.insert(titles, { title = title, filepath = file })
            end
        end
    end
    return titles
end

-- Markdown ファイルをタイトルで開くためのメイン関数
function M.open_markdown_by_title()
    local current_dir = vim.fn.getcwd()        -- 現在の作業ディレクトリを取得
    local titles = extract_titles(current_dir) -- 現在のディレクトリを引数に渡す

    -- Telescope ピッカーを起動
    pickers.new({}, {
        prompt_title = 'Open Markdown by Title',
        finder = finders.new_table({
            results = titles,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.title,
                    ordinal = entry.title,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd('edit ' .. selection.value.filepath)
            end)
            return true
        end,
    }):find()
end

-- 設定を行うための関数
function M.setup()
    vim.api.nvim_set_keymap('n', '<Leader>oo',
        "<cmd>lua require('plugins.tkancf.markdown_title_picker').open_markdown_by_title()<CR>",
        { noremap = true, silent = true })
end

-- モジュールテーブルを返す
return M
