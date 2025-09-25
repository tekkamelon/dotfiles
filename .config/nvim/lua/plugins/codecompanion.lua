-- codecompanion.lua
-- neovim >= 0.11.0


if not vim.g.vscode then

	-- システムプロンプトを読み込み
	local my_sys_prompt = require('plugins.cc_config.sys_prompt')

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

				opts = {

					system_prompt = my_sys_prompt,

				},

			},

			inline = {

				adapter = "openrouter",

				opts = {

					system_prompt = my_sys_prompt,

				},

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

			-- LM Studioの設定
			lmstudio = function()

				return require("codecompanion.adapters").extend("openai_compatible", {

					env = {

						url = "localhost:1234",

					},

					schema = {

						model = {

							default = "Qwen3-30B-A3B-Instruct-2507",

						},

					},

				})

			end,
		},

	}

end

