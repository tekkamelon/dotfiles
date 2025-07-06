-- codecompanion.lua


if not vim.g.vscode then

	require('codecompanion').setup{

		strategies = {

			chat = {

			  adapter = "copilot",

			},

			inline = {

			  adapter = "copilot",

			},

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

