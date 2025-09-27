-- codecompanion.lua
-- neovim >= 0.11.0


if not vim.g.vscode then

	-- 環境変数からユーザー名を取得,なければ"User"
	local username = os.getenv("USER") or "User"

	-- 環境変数からLLMを取得
	local llm_model = os.getenv("OPENAI_MODEL")

	-- 環境変数からAPIキーを取得,設定されていない場合はエラーメッセージを表示
	local api_key = assert(os.getenv("OPENROUTER_API_KEY"), 'OPENROUTER_API_KEY env not set')

	-- システムプロンプトを読み込み
	local my_sys_prompt = require('plugins.cc_config.sys_prompt')

	require('codecompanion').setup{

		display = {

			chat = {

				-- 自動スクロールをオフ
				auto_scroll = false,

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

				roles = {

					-- ユーザー名の表示
					user = username,

					-- アシスタント名の表示
					llm = function(adapter)

						return "assistant(" .. adapter.formatted_name .. ")"

					end,

				},

			},

			inline = {

				adapter = "openrouter",

				opts = {

					system_prompt = my_sys_prompt,

				},

			},

			agent = {

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

				return require('codecompanion.adapters').extend("openai_compatible", {

					env = {

						url = "https://openrouter.ai/api",
						api_key = api_key,
						chat_url = "/v1/chat/completions",

					},

					schema = {

						model = {

							default = llm_model,

						},

					},

				})

			end,

			-- LM Studioの設定
			lmstudio = function()

				return require('codecompanion.adapters').extend("openai_compatible", {

					env = {

                        url = "http://localhost:1234/v1",

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

