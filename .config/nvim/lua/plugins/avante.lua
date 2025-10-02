-- ,avante.lua
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
				-- OpenAI互換
				__inherited_from = 'openai',
				-- エンドポイントURL
				endpoint = os.getenv('OPENAI_BASE_URL') or 'https://openrouter.ai/api/v1',
				-- APIキー名
				api_key_name = 'OPENROUTER_API_KEY',
				-- 使用モデル
				model = llm_model,
			},
			lmstudio = {
				__inherited_from = 'openai',
				endpoint = 'http://localhost:1234/v1',
				api_key_name = '',
				model = 'qwen3-coder-30b-a3b-instruct',
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
			-- 差分を最小化
			minimize_diff = true,
		},

		config = {

			selector = {
				provider = "telescope",
			},
			-- 検索エンジン
			web_search_engine = {
				provider = "brave",
			}

		},

		-- ウィンドウ設定
		windows = {
			-- テキストを折り返す
			wrap = true,
			-- ウィンドウ幅
			width = 36,
			-- チャットバッファの設定
			input = {
				prefix = "> ",
				height = 12,
			}
		},

		custom_tools = function()
        return {
            require("mcphub.extensions.avante").mcp_tool(),
        }

    end,
	}
end

