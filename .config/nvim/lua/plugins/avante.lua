-- avante.lua
-- Neovim >= 0.11.0

-- LLMの温度
local temperature_param = 0.1

if vim.g.vscode then return end

-- 環境変数からLLMを取得,設定されていない場合は通知
local llm_model = vim.env.OPENAI_MODEL or "z-ai/glm-4.5-air:free"
if not vim.env.OPENAI_MODEL then
	vim.notify("環境変数'OPENAI_MODEL'が設定されていません.デフォルト値'" .. llm_model .. "'を使用します.", vim.log.levels.WARN)
end

-- APIキー設定チェック関数
local function check_api_keys()
	if not vim.env.OPENROUTER_API_KEY then
		vim.notify("OPENROUTER_API_KEYが設定されていません", vim.log.levels.WARN)
	end
end

-- 起動時にAPIキー設定をチェック
check_api_keys()

-- 環境変数からプロバイダ名を取得,なければ"openrouter"
local provider_name = vim.env.AVANTE_PROVIDER or "openrouter"

-- 起動時にプロバイダを通知
vim.notify("provider: " .. provider_name, vim.log.levels.INFO)

-- -- プロバイダがopencodeの場合は起動時に新規チャットを開始
if provider_name == "opencode" then
	-- 確実に起動を待つために1秒遅延
	vim.defer_fn(function()
		vim.cmd("AvanteChatNew")
	end, 1000)
end

-- 無効化するツール
local DISABLED_TOOLS = {
	"rag_search",
	"delete_path",
	"git_commit",
	-- "git_diff",
	-- "move_path",
	-- "copy_path",
	-- "create_dir"
}

-- カスタムプロンプトを読み込み
local shortcuts = require("plugins.avante_shortcuts")

require('avante').setup {

	-- デフォルトのプロバイダ
	-- opencodeが利用可能ならopencode,そうでなければopenrouter
	provider = provider_name,
	auto_suggestions_provider = "openrouter",
	---@alias Mode "agentic" | "legacy"
	---@type Mode
	mode = "agentic",

	-- CLIコーディングエージェント
	acp_providers = {
		-- モデルは`~.config/opencode/opencode.json`で指定
		["opencode"] = {
			command = "opencode",
			args = { "acp" }
		},

		["gemini-cli"] = {
			command = "gemini",
			args = { "--experimental-acp" }
		},

		-- openrouterを使用,LLMは環境変数で設定
		["qwen-code"] = {
			command = "qwen",
			args = { "--acp" },
		},

	},

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
		["mistralai/devstral-2512:free"] = {
			__inherited_from = 'openai',
			model = 'mistralai/devstral-2512:free',
		},
		["openrouter/glm-4.5-air:free"] = {
			__inherited_from = 'openai',
			model = llm_model,
		},
		["openrouter/glm-4.7"] = {
			__inherited_from = 'openai',
			model = 'z-ai/glm-4.7',
		},
		["openrouter/grok-4.1-fast"] = {
			__inherited_from = 'openai',
			model = 'x-ai/grok-4.1-fast',
		},
		["openrouter/grok-code-fast-1"] = {
			__inherited_from = 'openai',
			model = 'x-ai/grok-code-fast-1',
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

		-- Gemini
		gemini = {
			api_key_name = "GEMINI_API_KEY",
			endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
			model = "gemini-2.5-flash",
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

	behaviour = {
		auto_suggestions = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		minimize_diff = true,
		auto_apply_diff_after_generation = false,
	},

	config = {
		-- 検索エンジン
		web_search_engine = {
			provider = "tavily",
			proxy = nil,
		}
	},

	windows = {
		wrap = true,
		width = 37,
		input = {
			prefix = "> ",
			height = 15,
		},
		ask = {
			start_insert = false,
			border = "rounded"
		},
	},

	suggestion = {
		debounce = 800,
	},

	selection = {
		enabled = false,
	},

	selector = {
		provider = "telescope",
	},

	custom_tools = function()
		return {
			require("mcphub.extensions.avante").mcp_tool(),
		}
	end,
	shortcuts = shortcuts,
}
