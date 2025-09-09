-- noice.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('noice').setup{

		-- メッセージ
		messages = {

			enabled = true,

		},

		-- 通知
		notify = {

			enabled = true,
			view = "mini",

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

end
