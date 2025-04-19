local function next_utf8_char_offset(string, byte_offset_to_char)
    char = vim.fn.strpart(string,
        byte_offset_to_char, 1, { chars = true })
    print("the char is " .. char)
    return byte_offset_to_char
        + vim.fn.strlen(char)
end

local function draw_box(top_left, bottom_right)
    local region = vim.fn.getregion(top_left, bottom_right, { type = "\22", eol = true })
    local region_display_width = vim.fn.strdisplaywidth(region[1])

    local regionpos = vim.fn.getregionpos(top_left, bottom_right, { type = "\22", eol = true })
    for k, line_segment in next, regionpos do
        local line_num = line_segment[1][2];
        local line = vim.fn.getline(line_num)

        local replacement = ''
        if k == 1 then
            replacement = '┏'
                .. string.rep("━", region_display_width - 2)
                .. '┓'
        elseif k == #region then
            replacement = '┗'
                .. string.rep("━", region_display_width - 2)
                .. '┛'
        else
            replacement = "┃"
                .. region[k]:sub(vim.fn.byteidx(region[k], 1) + 1
                , vim.fn.byteidx(region[k], region_display_width - 1))
                .. "┃"
        end

        line_end = next_utf8_char_offset(line, line_segment[2][3] - 1) + 1

        -- nvim_* api seem to treat positions as 0-based
        -- while legacy functions - as 1-based
        vim.api.nvim_buf_set_text(0, line_num - 1, line_segment[1][3] - 1,
            line_num - 1, line_end - 1, { replacement })
    end
end

local function draw_line(top_left, bottom_right)
    local region = vim.fn.getregion(top_left, bottom_right, { type = "\22", eol = true })
    local region_display_width = vim.fn.strdisplaywidth(region[1])
    local region_height = #region
    if region_display_width == 1 then
        -- draw a vertical line
        local region_pos = vim.fn.getregionpos(top_left, bottom_right, { type = "\22", eol = true })
        for k, line_pos in next, region_pos do
            local column_pos = {
                line = line_pos[1][2],
                byte_offset = line_pos[1][3]
            }
            local line = vim.fn.getline(column_pos.line)
            local next_char_pos = next_utf8_char_offset(line,
                column_pos.byte_offset - 1) + 1
            vim.api.nvim_buf_set_text(0, column_pos.line - 1,
                column_pos.byte_offset - 1,
                column_pos.line - 1, next_char_pos - 1, { '│' })
        end
    else
        -- draw a horizontal line
        local line = vim.fn.getline(top_left[2])
        local line_end = next_utf8_char_offset(line, bottom_right[3] - 1) + 1
        local replacement = string.rep("─", region_display_width);
        vim.api.nvim_buf_set_text(0, top_left[2] - 1, top_left[3] - 1,
            bottom_right[2] - 1, line_end - 1, { replacement })
    end
end

vim.api.nvim_create_user_command('DrawBox', function(opts)
        if vim.fn.mode() == "\22" then -- visual block mode
            -- fetch corners of the selection box
            local current_pos = vim.fn.getpos('.')
            local opposite_pos = vim.fn.getpos('v')
            local corners = { current_pos, opposite_pos }

            table.sort(corners, function(a, b)
                if a[3] == b[3] then
                    return a[2] < b[2]
                else
                    return a[3] < b[3]
                end
            end)


            local region = vim.fn.getregion(corners[1], corners[2], { type = "\22", eol = true })
            local region_display_width = vim.fn.strdisplaywidth(region[1])
            local region_height = #region

            -- TODO just pass regionpos (and possibly region to draw_line|box) functions
            if region_height == 1 or region_display_width == 1 then
                draw_line(corners[1], corners[2])
            else
                draw_box(corners[1], corners[2])
            end
        end
    end,
    { nargs = 1, range = true })

vim.keymap.set('v', '<leader>b',
    function()
        vim.cmd.DrawBox("visual")
    end
    , { noremap = true });
