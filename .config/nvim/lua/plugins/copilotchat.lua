-- copilotchat.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	-- 環境変数からユーザー名を取得,なければ"User"
	local username = os.getenv("USER") or "User"
	local my_sys_prompt = "日本語かつ絵文字を使わずに読書家のメイド口調でお願いします。私に呼びかける際はご主人様と呼んでください"

	-- CopilotChatプラグインのセットアップ
	require("CopilotChat").setup{

		headers = {

			-- ユーザー名の表示
			user = '## ' .. username .. ' ',

			-- アシスタント名の表示
			assistant = '## assistant '

		},

		-- デフォルトの言語
		language = 'Japanese',

		auto_fold = false,

		-- openrouterのモデル
		model = "deepseek/deepseek-chat-v3-0324:free",

		-- github copilotのモデル
		-- model = "gpt-5-mini",

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

						-- 
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

				prompt = "/COPILOT_REVIEW #buffer コードを日本語でレビューし,改善したコードを提供してください",
				description = "品質レビュー",
				system_prompt = my_sys_prompt,

			},

			Fix = {

				prompt = "/COPILOT_FIX #buffer エラーを修正したコードを提供してください",
				description = "エラー修正",
				system_prompt = my_sys_prompt,

			},

			Optimize = {

				prompt = "/COPILOT_REFACTOR #buffer より効率を向上させたコードを提供してください",
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

	-- LM Studioプロバイダの設定
	require('CopilotChat.config').providers.lmstudio = {

		-- 入力データの準備
		prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,

		-- 出力データの整形
		prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,

		-- 利用可能なモデルリストを取得する関数
		get_models = function(headers)

			-- LM StudioのローカルAPIエンドポイントにGETリクエストを送信
			local response, err = require('CopilotChat.utils').curl_get('http://localhost:1234/v1/models', {

				-- リクエストヘッダー
				headers = headers,
				-- JSON形式のレスポンスを期待
				json_response = true

			})

			-- エラー発生時は処理を中断
			if err then
				error(err)
			end

			-- レスポンスデータからモデル情報を抽出・整形
			return vim.tbl_map(function(model)

				return {

					-- モデルID
					id = model.id,
					-- モデル名（IDをそのまま使用）
					name = model.id,

				}

			end, response.body.data)

		end,

		-- チャット補完APIのエンドポイントURLを返す
		get_url = function()

			-- 環境変数からlmstudioのエンドポイントURLを取得,なければデフォルト
			local api_url = os.getenv("LMSTUDIO_API_URL") or "http://localhost:1234/v1/chat/completions"
			return api_url

		end,

	}

end

