-- noice.lua


-- vscodeから起動していなければ真
if vim.g.vscode then return end
require('noice').setup {

	-- メッセージ
	messages = {

		-- これを"true"にするとキーボードマクロが機能しない
		enabled = false,

	},

	-- 通知
	notify = {

		enabled = true,
		view = "mini",

	},

	routes = {
		{
		-- avante + grok ACP が送る独自 method (_x.ai/*) は未対応警告を出さない
			filter = {
				event = "notify",
				find = "Unknown notification method: _x%.ai/",
			},
			opts = { skip = true },
		},
		{
			-- img-clipの"Content is not an image."の通知を無視
			filter = {
				event = "notify",
				find = "Content is not an image%.",
			},
			opts = { skip = true },
		},
	},

	-- コマンドライン
	cmdline = {

		enabled = true,

		format = {

			-- 各種プロンプトの設定
			cmdline = { pattern = "^:", icon = ":", lang = "vim" },
			search_down = { kind = "search", pattern = "^/", icon = "🔎 /", lang = "regex" },
			search_up = { kind = "search", pattern = "^%?", icon = "🔍 ?", lang = "regex" },
			lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "🌙 ", lang = "lua" },
			help = { pattern = "^:%s*he?l?p?%s+", icon = "📖" },

		},

	},

	format = {

		level = {

			icons = {

				error = "❌",
				warn = " ⚠ ",
				info = "💻"

			},

		},
	},

	popupmenu = {

		kind_icons = false,

	},

}
-- end
