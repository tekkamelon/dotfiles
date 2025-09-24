-- codecompanion.lua


if not vim.g.vscode then

	require('codecompanion').setup{

		display = {

			chat = {

				-- チャットバッファの設定
				window = {

					layout = 'horizontal',
					width = 0.5,
					height = 0.4,

				}

			},
		},

		strategies = {

			chat = {

			  adapter = "copilot",

			},

			inline = {

			  adapter = "copilot",

			},

		},

		opts = {

			-- デフォルトの言語
			language = "Japanese"

    	},

		adapters = {

			-- copilotアダプタを上書き
			copilot = function()

			-- 既定のcopilotアダプタをベースに
			return require("codecompanion.adapters").extend("copilot", {

				schema = {

					model = {

					  default = "gpt-4.1",

					},

				},
			})

			end,
		},

	}

end

