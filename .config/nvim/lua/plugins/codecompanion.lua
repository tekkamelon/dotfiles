-- codecompanion.lua


if not vim.g.vscode then

	require('codecompanion').setup{

		opts = {

			language = "Japanese",

		},

		window = {

			layout = "float", -- vertical|horizontal|buffer
			-- position = "bottom",   -- 明示的に下部に配置

		},

		display = {

			chat = {

				auto_scroll = false,
			},

		},

		strategies = {

			chat = {

				adapter = "openrouter",

				-- デフォルトでバッファを読み取る
				variables = {

					["buffer"] = {

						opts = {

							default_params = 'watch', -- or 'pin'

						},

					},

				},

			},

			agent = {

				adapter = "openrouter",

			},

			inline = {

			  adapter = "openrouter",

			},

		},

		adapters = {

			-- copilotアダプタを上書き
			openrouter = function()

			-- 既定のcopilotアダプタをベースに
			return require("codecompanion.adapters").extend("openai", {

				name = "openrouter",
				url = "https://openrouter.ai/api/v1/chat/completions",

				env = {
					api_key = "OPENROUTER_API_KEY",
				},

				headers = {
					["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim",
					["X-Title"] = "codecompanion.nvim",
				},

				parameters = {
					stream = true,
				},

				schema = {
					model = {
						-- 使用したいモデルを指定
						default = "deepseek/deepseek-chat-v3-0324:free",
					},

				},

			})

			end,
		},

	}

end

