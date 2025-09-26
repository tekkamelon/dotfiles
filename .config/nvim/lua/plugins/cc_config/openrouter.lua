-- openrouter.lua


require('CopilotChat.config').providers.openrouter = {

	-- 入力データの準備
	prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,

	-- 出力データの整形
	prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,

	-- リクエストヘッダーの取得
	get_headers = function()

		-- 環境変数からAPIキーを取得,設定されていない場合はエラーメッセージを表示
		local api_key = assert(os.getenv('OPENROUTER_API_KEY'), 'OPENROUTER_API_KEY env not set')

		return {

			-- Bearerトークン形式の認証ヘッダー
			Authorization = 'Bearer ' .. api_key,
			-- JSON形式のリクエストを示すヘッダー
			['Content-Type'] = 'application/json',

		}

	end,

	-- 利用可能なモデルリストを取得する関数
	get_models = function(headers)

		-- OpenRouterのAPIエンドポイントにGETリクエストを送信
		local response, err = require('CopilotChat.utils').curl_get('https://openrouter.ai/api/v1/models', {

			-- リクエストヘッダー
			headers = headers,
			-- JSON形式のレスポンスを期待
			json_response = true,

		})

		-- エラー発生時は処理を中断
		if err then

			error(err)

		end

		-- レスポンスデータからモデル情報を抽出・整形
		return vim.iter(response.body.data)

			:map(function(model)

				return {

					-- モデルID
					id = model.id,
					-- モデル名
					name = model.name,

				}

			end)

			:totable()

	end,

	-- チャット補完APIのエンドポイントURLを返す
	get_url = function()

		-- 環境変数からAPIエンドポイントを取得,設定されていない場合はopenrouterのAPIを利用
		local api_url = os.getenv('OPENAI_BASE_URL') or 'https://openrouter.ai/api'
		return api_url .. '/chat/completions'

	end,

}
