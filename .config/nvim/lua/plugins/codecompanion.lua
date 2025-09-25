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

			  adapter = "openrouter",

			},

			inline = {

			  adapter = "openrouter",

			},

		},

		opts = {

			-- デフォルトの言語
			language = "Japanese"

    	},

		-- アダプター
		adapters = {

			-- OpenRouterの設定
			openrouter = function()

				return require("codecompanion.adapters").extend("openai_compatible", {

					env = {

						url = "https://openrouter.ai/api",
						api_key = os.getenv("OPENROUTER_API_KEY"),
						chat_url = "/v1/chat/completions",

					},

					schema = {
						model = {

							default = os.getenv("OPENAI_MODEL"),

						},

					},

				})

			end,

		},

	}

end

