-- lmstudio.lua


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

