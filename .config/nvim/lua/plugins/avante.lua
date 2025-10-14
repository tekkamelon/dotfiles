-- avante.lua
-- Neovim >= 0.11.0

if vim.g.vscode then return end

-- 環境変数からLLMを取得,なければOpenRouterのfreeモデル
local llm_model = vim.env.OPENAI_MODEL or "z-ai/glm-4.5-air:free"
if not vim.env.OPENAI_MODEL then
	vim.notify("環境変数'OPENAI_MODEL'が設定されていません.デフォルト値'z-ai/glm-4.5-air:free'を使用します.", vim.log.levels.WARN)
end

-- 無効化するツール
local DISABLED_TOOLS = { "rag_search", "git_diff", "git_commit" }

require('avante').setup {

	-- OpenAI互換
	provider = "openai",

	auto_suggestions_provider = "openrouter",

	providers = {
		-- OpenAI互換の基本設定
		openai = {
			endpoint = vim.env.OPENAI_BASE_URL or 'https://openrouter.ai/api/v1',
			api_key_name = 'OPENROUTER_API_KEY',
			model = llm_model,
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = 0.35,
			},
		},

		-- OpenRouterで利用するモデル一覧
		["openrouter/glm-4.5-air:free"] = {
			__inherited_from = 'openai',
			model = 'z-ai/glm-4.5-air:free',
		},
		["openrouter/deepseek-chat-v3-0324:free"] = {
			__inherited_from = 'openai',
			model = 'deepseek/deepseek-chat-v3-0324:free',
		},
		["openrouter/llama-4-maverick:free"] = {
			__inherited_from = 'openai',
			model = 'meta-llama/llama-4-maverick:free',
		},
		["openrouter/llama-4-scout:free"] = {
			__inherited_from = 'openai',
			model = 'meta-llama/llama-4-scout:free',
		},
		["openrouter/qwen3-coder:free"] = {
			__inherited_from = 'openai',
			model = 'qwen/qwen3-coder:free',
		},

		-- OpenRouter(プロバイダとして明示)
		openrouter = {
			-- OpenAI互換
			__inherited_from = 'openai',
			endpoint = vim.env.OPENAI_BASE_URL or 'https://openrouter.ai/api/v1',
			api_key_name = 'OPENROUTER_API_KEY',
			model = llm_model,
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = 0.35,
			},
		},

		-- LM Studio
		lmstudio = {
			__inherited_from = 'openai',
			endpoint = vim.env.LMSTUDIO_API_URL or 'http://localhost:1234/v1',
			api_key_name = '',
			model = 'qwen3-coder-30b-a3b-instruct',
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = 0.35,
			},
		},
	},

	shortcuts = {
		{
			name = "explain",
			description = "詳細解説",
			prompt = "現在のコードを日本語で解説して下さい",
		},
		{
			name = "review",
			description = "品質レビュー",
			prompt = "現在のコードを日本語でレビュー,良い点と改善すべき点を指摘してください",
		},
		{
			name = "fix",
			description = "品質レビュー",
			prompt = "現在発生しているエラーを修正したコードを提供して下さい",
		},
		{
			name = "refactor",
			description = "最適化",
			prompt = "現在のコードをより効率を向上させたコードを提供して下さい",
		},
		{
			name = "test",
			description = "テスト追加",
			prompt = "コードに適切なテストを追加して下さい",
		},
		{
			name = "comment",
			description = "コメント追加",
			prompt = "コードに日本語で適切なコメントを入れてください.ただし,コードとコメントの行を分けてください",
		},
		{
			name = "words",
			description = "用語解説",
			prompt = "選択範囲の解説を日本語かつ2から3行程度で書き込んでください",
		},
		{
			name = "matome",
			description = "各章ごとのまとめ",
			prompt = "各章ごとの内容をまとめつつ,得られた総合的な知見を最終行以降に記述して下さい",
		},
	},

	behaviour = {
		auto_suggestions = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		minimize_diff = true,
		auto_apply_diff_after_generation = false,
	},

	config = {
		selector = {
			provider = "telescope",
		},
		-- 検索エンジン
		web_search_engine = {
			provider = "tavily",
			proxy = nil,
		}
	},

	windows = {
		wrap = true,
		width = 36,
		input = {
			prefix = "> ",
			height = 12,
		},
		ask = {
			start_insert = false,
			border = "rounded"
		},
	},

	custom_tools = function()
		return {
			require("mcphub.extensions.avante").mcp_tool(),
		}
	end,
}
