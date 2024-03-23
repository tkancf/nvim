local function format_current_time()
    return os.date("%Y-%m-%d %H:%M:%S")
end

local function insert_new_clock_block(datetime)
    vim.cmd("normal! o@end")
    vim.cmd("normal! O" .. datetime .. " - ")
    vim.cmd("normal! O@clock")
    vim.cmd("normal! j")
end

local function seconds_to_time_format(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor(seconds % 3600 / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function update_current_line_with_end_time(line, datetime)
    -- 開始時刻を抽出
    local start_time_str = line:match("(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d)")
    local pattern = "(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d)"
    local year, month, day, hour, min, sec = start_time_str:match(pattern)
    local start_time = os.time({ year = year, month = month, day = day, hour = hour, min = min, sec = sec })

    -- 終了時刻を取得
    local end_time = os.time()

    -- 時差を計算
    local elapsed_time = end_time - start_time
    local elapsed_time_str = seconds_to_time_format(elapsed_time)

    -- 行に終了時刻と経過時間を追加
    local new_line = string.format("%s%s (Elapsed: %s)", line, datetime, elapsed_time_str)
    vim.api.nvim_set_current_line(new_line)
end


local function insert_start_time_block(datetime)
    vim.cmd("normal! o" .. datetime .. " - ")
end

local function handle_clock_insertion()
    local line = vim.api.nvim_get_current_line()
    local start_pattern = "%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d %- $"
    local end_pattern = "%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d %- %d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d"
    local datetime = format_current_time()

    if line:match(end_pattern) then
        insert_start_time_block(datetime)
    elseif line:match(start_pattern) then
        update_current_line_with_end_time(line, datetime)
    else
        insert_new_clock_block(datetime)
    end
end

vim.api.nvim_set_keymap('n', '<C-t>', '', { noremap = true, callback = handle_clock_insertion })

