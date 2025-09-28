-- avante.lua
-- Neovim >= 0.11.0

if not vim.g.vscode then
	-- 環境変数からLLMを取得,なければ"x-ai/grok-4-fast:free"
	local llm_model = os.getenv("OPENAI_MODEL") or "x-ai/grok-4-fast:free"

	require('avante').setup{
		-- デフォルトプロバイダ
		provider = "openrouter",
		-- 自動提案のプロバイダ
		auto_suggestions_provider = "openrouter",

		-- プロバイダの設定
		providers = {
			openrouter = {
				-- OpenAIから継承
				__inherited_from = 'openai',
				-- エンドポイントURL
				endpoint = os.getenv('OPENAI_BASE_URL') or 'https://openrouter.ai/api/v1',
				-- APIキー名
				api_key_name = 'OPENROUTER_API_KEY',
				-- 使用モデル
				model = llm_model,
			},
		},

		-- 動作設定
		behaviour = {
			-- 自動提案を無効
			auto_suggestions = false,
			-- ハイライトグループを自動設定
			auto_set_highlight_group = true,
			-- キーマップを自動設定
			auto_set_keymaps = true,
			-- 生成後の差分を自動適用しない
			auto_apply_diff_after_generation = false,
			-- クリップボードからの貼り付けをサポートしない
			support_paste_from_clipboard = false,
			-- 差分を最小化
			minimize_diff = true,
		},

		-- コンフィグ設定
		config = {

			selector = {
				-- セレクタプロバイダとしてTelescopeを使用
				provider = "telescope",
			},

		},

		-- ウィンドウ設定
		windows = {
			-- テキストを折り返す
			wrap = true,
			-- ウィンドウ幅
			width = 36,
			-- チャットバッファの設定
			input = {
				-- 入力プレフィックス
				prefix = "> ",
				-- 入力高さ
				height = 13,
			}
		},
	}
end

