function draw_box(top_left, bottom_right)
	region = vim.fn.getregion(top_left, bottom_right, {type ="\22", eol = true})
	region_display_width = vim.fn.strdisplaywidth(region[1])

	regionpos = vim.fn.getregionpos(top_left, bottom_right, {type ="\22", eol = true})
	for k, line_segment in next, regionpos do
		line_num = line_segment[1][2];
		line = vim.fn.getline(line_num)

		--replacement = string.rep("━", region_display_width)
		replacement = ''
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
			,vim.fn.byteidx(region[k], region_display_width - 1))
			.. "┃"
		end

		-- line_segment hold position in bytes. 
		-- Hence conversion to character idx, increment
		-- and then conversion back to byte idx.
		-- All because nvim_buf_set_text treats column ranges as end-exclusive.
		line_end = vim.fn.byteidx(line, vim.fn.charidx(line, line_segment[2][3] - 1)+1)
		line_end = line_end >= 0 and line_end or line_segment[2][3]+1

		-- nvim_* api seem to treat positions as 0-based
		-- while legacy functions - as 1-based
		vim.api.nvim_buf_set_text(0, line_num - 1, line_segment[1][3] - 1,
		line_num -1, line_end , {replacement})
	end
end

------ This is just gonna be here for the time being
vim.api.nvim_create_user_command('DrawBox', function (opts)
	if vim.fn.mode() == "\22" then  -- visual block mode
		-- fetch corners of the selection box
		current_pos = vim.fn.getpos('.')
		opposite_pos = vim.fn.getpos('v')
		corners = {current_pos, opposite_pos}

		table.sort(corners, function(a, b) 
			if a[3] == b[3] then
				return a[2] < b[2]
			else
				return a[3] < b[3]
			end
		end)

		-- change the lines with getline/setline
		draw_box(corners[1], corners[2])
	end
end, 
{nargs = 1, range = true})

vim.keymap.set('v', '<leader>b',
function()
	vim.cmd.DrawBox("visual")
end
,{noremap = true });
