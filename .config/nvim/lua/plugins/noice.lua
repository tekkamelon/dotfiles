-- noice.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('noice').setup{

		-- 通知の設定
		messages = {

			enabled = false,

		},

		notify = {

			enabled = true,
			view = "mini",

		},

		cmdline = {

			enabled = true,

			format = {

				-- 各種プロンプトの設定
				cmdline = { pattern = "^:", icon = ">", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = "🔎 /", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = "🔍 ?", lang = "regex" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "🌙 ", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "📖" },

			},

		},

	}

end
