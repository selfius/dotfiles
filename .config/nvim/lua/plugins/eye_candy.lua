return {
	{ "rebelot/kanagawa.nvim", 
	lazy = false,
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme kanagawa]])
	end,
	},

	{"nanozuki/tabby.nvim",
	config = function()
		local theme = {
		  fill = 'TabLineFill',
		  head = 'TabLine',
		  current_tab = 'TabLineSel',
		  tab = 'TabLine',
		  win = 'TabLine',
		  tail = 'TabLine',
		}
		require('tabby').setup({
		line = function(line)
		    return {
		      line.tabs().foreach(function(tab)
			local hl = tab.is_current() and theme.current_tab or theme.tab
			return {
			  line.sep('', hl, theme.fill),
			  tab.is_current() and '' or '󰆣',
			  tab.name(),
			  line.sep('', hl, theme.fill),
			  hl = hl,
			  margin = ' ',
			}
		      end),
		      hl = theme.fill,
		    }
		  end,
		  option = {
			tab_name = {
			    name_fallback = function(tabid)
			      return tabid
			      end,
			    override = nil,
			  },
		  }
	  })
	end,
	}
}
