-- copilotchat.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	-- 環境変数からユーザー名を取得,なければ"User"
	local username = os.getenv("USER") or "User"
	local my_sys_prompt = "日本語かつ絵文字を使わずに読書家のメイド口調でお願いします。私に呼びかける際はご主人様と呼んでください"

	-- CopilotChatプラグインのセットアップ
	require("CopilotChat").setup{

		-- ユーザーの表示
		question_header = '# ' .. username .. ' ',

		-- openrouterのモデル
		-- GitHub cpolitが上限に達した場合はこちらを使用
		-- model = "deepseek/deepseek-chat-v3-0324:free",

		-- デフォルトのモデル
		model = "gpt-4.1",

		-- プロバイダーを明示的に指定
		provider = "openrouter",

		-- プロバイダーの設定
		providers = {

			-- OpenRouterプロバイダーの設定
			openrouter = {

				-- 入力データを準備する関数
				prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,

				-- 出力データを整形する関数
				prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

				-- APIリクエスト用のヘッダーを生成する関数
				get_headers = function()

					-- 環境変数からOPENROUTER_API_KEYを取得,存在しない場合はエラーメッセージを表示
					local api_key = assert(os.getenv("OPENROUTER_API_KEY"), "環境変数 OPENROUTER_API_KEY が設定されていません")

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
						local models = response.body.data
						local formatted_models = {}

						for _, model in ipairs(models) do

							table.insert(formatted_models, { id = model.id, name = model.name })
						end

					return formatted_models

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

		show_help = true,

		-- システムプロンプト
		system_prompt = my_sys_prompt,

		-- プロンプトのテンプレート
		prompts = {

			Explain = {

				prompt = "/COPILOT_EXPLAIN #buffer コードを日本語で解説してください",
				description = "詳細解説",
				system_prompt = my_sys_prompt,

			},

			Review = {

				prompt = "/COPILOT_REVIEW #buffer コードを日本語でレビューしてください",
				description = "品質レビュー",
				system_prompt = my_sys_prompt,

			},

			Fix = {

				prompt = "/COPILOT_FIX #buffer コードのエラーを修正してください",
				description = "エラー修正",
				system_prompt = my_sys_prompt,

			},

			Optimize = {

				prompt = "/COPILOT_REFACTOR #buffer コードをより効率的にしてください",
				description = "最適化",
				system_prompt = my_sys_prompt,

			},

			Tests = {

				prompt = "#buffer コードに適切なテストを追加してください",
				description = "テスト追加",
				system_prompt = my_sys_prompt,

			},

			Comment = {

				prompt = "#buffer コードに日本語で適切なコメントを入れてください",
				description = "コメント追加",
				system_prompt = my_sys_prompt,


			},

		},

		sticky = {

			'#buffer',

		},

	}

end

