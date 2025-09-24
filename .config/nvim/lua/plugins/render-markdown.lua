-- render-markdown.lua


require('render-markdown').setup{

	render_modes = true,

	-- 見出しの設定
	heading = {enabled = false},
	sign = {enabled = false},

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

		-- 箇条書きの処理を無効化または調整
		enabled = false,

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

