-- copilotchat.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	-- CopilotChatプラグインのセットアップ
	require("CopilotChat").setup {

		-- openrouterのモデル
		-- model = "deepseek/deepseek-chat-v3-0324:free",

		-- 30日間の無料トライアル
		model = "claude-sonnet-4",

		-- プロバイダーを明示的に指定
		provider = "openrouter",

		-- プロバイダーの設定
		providers = {

			-- OpenRouterプロバイダーの設定
			openrouter = {

				-- 入力データを準備する関数
				prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
				-- prepare_input = custom_prepare_input,

				-- 出力データを整形する関数
				prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

				-- APIリクエスト用のヘッダーを生成する関数
				get_headers = function()

					-- 環境変数からOPENROUTER_API_KEYを取得
					local api_key = assert(os.getenv("OPENROUTER_API_KEY"), "OPENROUTER_API_KEY env not set")

						-- 認証情報を含むヘッダーテーブルを返す
						return {

							Authorization = "Bearer " .. api_key,

							["Content-Type"] = "application/json",

						}

				end,

				-- 利用可能なモデルのリストを取得する関数
				get_models = function(headers)

					-- OpenRouterのAPIからモデルリストをGETリクエストで取得
					local response, err = require("CopilotChat.utils").curl_get(

						"https://openrouter.ai/api/v1/models",

						{ headers = headers, json_response = true }

					)

					-- エラーの場合は処理を中断
					if err then error(err) end

						-- レスポンスボディからモデルデータを抽出,整形してテーブルとして返す
						return vim.iter(response.body.data)

						:map(function(model)

							return { id = model.id, name = model.name }

						end)

						:totable()

				end,

				-- チャット補完APIのエンドポイントURLを返す関数
				get_url = function()

				return "https://openrouter.ai/api/v1/chat/completions"

				end,

			},

		},

		-- チャットバッファの設定
		window = {

			layout = 'horizontal',
			width = 0.5,
			height = 0.4,

		},

		show_help = "yes",

		-- プロンプトのテンプレート
		prompts = {

			Explain = {

				prompt = "/COPILOT_EXPLAIN #buffer このコードについて解説してください",
				description = "コードの解説をしてもらう",

			},

			Fix = {

				prompt = "/COPILOT_FIX #buffer このコードのエラーを修正してください",
				description = "コードの修正をしてもらう",

			},

			Comment = {

				prompt = "#buffer このコードに適切なコメントを入れてください",
				description = "コードにコメントを記述してもらう",

			},

			Optimize = {

				prompt = "/COPILOT_REFACTOR #buffer このコードをより効率よく書ける箇所を教えてください",
				description = "コードを最適化してもらう",

			},

		},

		system_prompt = "日本語かつ絵文字を使わずに読書家のメイド口調でお願いします。私に呼びかける際はご主人様と呼んでください",

		sticky = {

			'#buffer',

		},

	}

end

