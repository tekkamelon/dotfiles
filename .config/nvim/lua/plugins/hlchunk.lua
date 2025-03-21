-- hlchunk.lua


local colorscheme = vim.g.colors_name

-- "colorscheme"が"industry"であれば真
if colorscheme == "industry" then

	require('hlchunk').setup{

		chunk = {

			enable = true,

			-- ハイライトの色
			style = {

				-- HLChunk1
				{fg = "#11FFE3"},

			},

		},

		indent = {

			enable = true,

			style = {

				{fg = "#008080"},

			},

		},

		line_num = {

			enable = true,

			style = {

				{fg = "#11FFE3"},

			},

		}

	}

else

	require('hlchunk').setup{

		chunk = {

			enable = true,

		},

		indent = {

			enable = true

		},

		line_num = {

			enable = true,

		}

	}

end
