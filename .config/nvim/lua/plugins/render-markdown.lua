-- render-markdown.lua


require('render-markdown').setup{

	render_modes = true,

	heading = {enabled = false},
	sign = {enabled = false},

	-- インデントの設定
	indent = {

		enabled = true,
		skip_heading = true,

	},

	-- コードブロックの設定
	code = {

		width = "block",
		left_pad = 0,
		right_pad = 0,
		highlight = '',

	},

	-- テキストの設定
	bullet = {

		icons = {'● ', '○ ', '● ', '○ '},

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

