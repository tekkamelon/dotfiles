-- render-markdown.lua


require('render-markdown').setup{

	render_modes = true,

	heading = {enabled = false},
	sign = {enabled = false},
	indent = {enabled = true},

	-- コードブロックの設定
	code = {

		width = "block",
		left_pad = 0,
		right_pad = 0,

	},

	-- リンクの設定
	link = {

		-- アイコンの設定
		image = '🖼 ',
		email = '📧 ',
		hyperlink = '🔗 ',

		custom = {

			web = { pattern = '^http', icon = '🌐' },
			github = { pattern = 'github%.com', icon = '🐙 ' },
			google = { pattern = 'google%.com', icon = '🔍 ' },

		}

	},

}

