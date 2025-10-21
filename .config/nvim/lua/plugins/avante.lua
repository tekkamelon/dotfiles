-- avante.lua
-- Neovim >= 0.11.0

-- LLMの温度
local temperature_param = 0.1

if vim.g.vscode then return end

-- 環境変数からLLMモデルを取得,設定されていない場合は通知
local model_from_env = vim.env.OPENAI_MODEL
local llm_model = model_from_env or "z-ai/glm-4.5-air:free"
if not model_from_env then
	vim.notify("環境変数'OPENAI_MODEL'が設定されていません.デフォルト値'" .. llm_model .. "'を使用します.", vim.log.levels.WARN)
end


-- APIキー設定チェック関数
local function check_api_keys()
	-- APIキー設定をチェックする関数
	-- 必要なAPIキーが設定されているか確認
	local required_keys = {
		OPENROUTER_API_KEY = "OpenRouter",
		GROQ_API_KEY = "Groq",
		GEMINI_API_KEY = "Gemini",
	}

	-- 設定されていないAPIキーを格納するテーブル
	local missing_keys = {}
	for key, _ in pairs(required_keys) do
		if not vim.env[key] then
			table.insert(missing_keys, required_keys[key])
		end
	end

	-- 設定されていないAPIキーがある場合に通知を表示
	if #missing_keys > 0 then
		vim.notify("以下のAPIキーが設定されていません: " .. table.concat(missing_keys, ", "), vim.log.levels.WARN)
	end
end

-- 起動時にAPIキー設定をチェック
check_api_keys()

-- 無効化するツール
local DISABLED_TOOLS = {
	"rag_search",
	"git_diff",
	"git_commit",
	"move_path",
	"copy_path",
	"delete_path",
	"create_dir"
}

require('avante').setup {

	-- デフォルトのプロバイダー
	provider = "openrouter",
	auto_suggestions_provider = "openrouter",
	---@alias Mode "agentic" | "legacy"
	---@type Mode
	mode = "agentic",

	providers = {
		-- OpenAI互換の基本設定
		openai = {
			endpoint = vim.env.OPENAI_BASE_URL or 'https://openrouter.ai/api/v1',
			api_key_name = 'OPENROUTER_API_KEY',
			model = llm_model,
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = temperature_param,
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
		["openrouter/deepcoder-14b-preview:free"] = {
			__inherited_from = 'openai',
			model = 'agentica-org/deepcoder-14b-preview:free',
		},
		["openrouter/grok-4-fast"] = {
			__inherited_from = 'openai',
			model = 'x-ai/grok-4-fast',
		},

		-- OpenRouter
		openrouter = {
			-- OpenAI互換
			__inherited_from = 'openai',
			endpoint = vim.env.OPENAI_BASE_URL or 'https://openrouter.ai/api/v1',
			api_key_name = 'OPENROUTER_API_KEY',
			model = llm_model,
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = temperature_param,
			},
		},

		-- Groq
		groq = {
			__inherited_from = "openai",
			api_key_name = "GROQ_API_KEY",
			endpoint = "https://api.groq.com/openai/v1/",
			model = "meta-llama/llama-4-scout-17b-16e-instruct",
			disable_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = temperature_param,
				max_tokens = 8192,
			},
		},

		-- Gemini
		gemini = {
			api_key_name = "GEMINI_API_KEY",
			endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
			model = "gemini-2.0-flash",
			disable_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = temperature_param,
			},
		},

		-- LM Studio
		lmstudio = {
			__inherited_from = 'openai',
			endpoint = vim.env.LMSTUDIO_API_URL or 'http://localhost:1234/v1',
			api_key_name = '',
			model = 'qwen3-coder-30b-a3b-instruct',
			-- すべてのツールを無効化
			disable_tools = true,
			extra_request_body = {
				temperature = temperature_param,
				max_tokens = 8192,
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
			prompt = "現在発生しているエラーを修正して下さい",
		},
		{
			name = "refactor",
			description = "最適化",
			prompt = "現在のコードをより効率を向上させたコードに変更して下さい",
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

	suggestion = {
		debounce = 800,
	},

	custom_tools = function()
		return {
			require("mcphub.extensions.avante").mcp_tool(),
		}
	end,
}
