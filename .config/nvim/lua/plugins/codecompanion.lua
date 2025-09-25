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

	}

end

