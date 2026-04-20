-- render-markdown.lua


require('render-markdown').setup {

	-- 挿入モードではレンダリングしない
	render_modes = true,

	-- ファイルタイプの設定
	file_types = {

		'markdown',
		'vimwiki',
		'Avante',
		'Agentic'

	},

	-- 見出しの設定
	heading = {
		width = "block",
		left_pad = 0,
		right_pad = 3,
		icons = {},
		enabled = false,
	},
	sign = { enabled = true },

	-- コードブロックの設定
	code = {

		width = "block",
		left_pad = 0,
		right_pad = 3,
		highlight = '',

	},

	-- テキストの設定
	bullet = {

		icons = { '● ', '○ ', '● ', '○ ' },

		-- 箇条書きの処理を無効化または調整
		enabled = true,

	},

	-- テーブルの設定
	pipe_table = {
		style = 'width'
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
