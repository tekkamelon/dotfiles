-- avante.lua
-- Neovim >= 0.11.0

-- LLMの温度
local temperature_param = 0.1

if vim.g.vscode then return end

-- APIキー設定チェック関数
local function check_api_keys()
	if not vim.env.OPENROUTER_API_KEY then
		vim.notify("OPENROUTER_API_KEYが設定されていません", vim.log.levels.WARN)
	end
end

-- 起動時にAPIキー設定をチェック
check_api_keys()

-- 環境変数からプロバイダ名を取得,なければ"openrouter/minimax-m2.5:free"を使用
local provider_name = vim.env.AVANTE_PROVIDER or "openrouter/minimax-m2.5:free"

-- 起動時にプロバイダを通知
vim.notify("provider: " .. provider_name, vim.log.levels.INFO)

-- 無効化するツール
local DISABLED_TOOLS = {
	"rag_search",
	"delete_path",
}

-- カスタムプロンプトを読み込み
local shortcuts = require("plugins.avante_shortcuts")

require('avante').setup {

	-- デフォルトのプロバイダ
	provider = provider_name,
	---@alias Mode "agentic" | "legacy"
	---@type Mode
	mode = "agentic",

	-- CLIコーディングエージェント
	-- コマンドと引数を指定してプロバイダを定義
	--  `:require("avante.api").switch_provider("opencode")` などで切り替え可能
	acp_providers = {
		["opencode"] = {
			command = "opencode",
			args = { "acp" }
		},

		["gemini-cli"] = {
			command = "gemini",
			args = { "--acp" }
		},

		["qwen-code"] = {
			command = "qwen",
			args = { "--acp" },
		},

		["goose"] = {
			command = "goose",
			args = { "acp" },
		},

		["cline"] = {
			command = "cline",
			args = { "--acp" },
		},

		["openhands"] = {
			command = "openhands",
			args = { "acp" },
		},

		["kilocode"] = {
			command = "kilocode",
			args = { "acp" },
		},
	},

	providers = (function()
		local providers = {}

		-- OpenRouterの共通設定
		local openrouter_base = {
			__inherited_from = 'openai',
			endpoint = "https://openrouter.ai/api/v1",
			api_key_name = 'OPENROUTER_API_KEY',
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = temperature_param,
			},
		}

		-- OpenRouterで使用するLLM
		local openrouter_models = {
			["openrouter/glm-4.5-air:free"] = 'z-ai/glm-4.5-air:free',
			["openrouter/minimax-m2.5:free"] = 'minimax/minimax-m2.5:free',
			["openrouter/glm-4.7"] = 'z-ai/glm-4.7',
			["openrouter/grok-4.1-fast"] = 'x-ai/grok-4.1-fast',
			["openrouter/grok-code-fast-1"] = 'x-ai/grok-code-fast-1',
		}

		-- OpenRouterプロバイダを動的に生成
		for provider_key, model in pairs(openrouter_models) do
			providers[provider_key] = vim.tbl_extend("force", openrouter_base, { model = model })
		end

		-- さくらのAI Engineの共通設定
		local sakura_base = {
			__inherited_from = 'openai',
			api_key_name = "SAKURA_API_KEY",
			endpoint = "https://api.ai.sakura.ad.jp/v1",
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = temperature_param,
			},
		}

		-- 使用するモデル
		local sakura_models = {
			["sakura/kimi-k2.5"] = "preview/Kimi-K2.5",
			["sakura/gpt-oss-120b"] = "gpt-oss-120b",
			["sakura/Qwen3-Coder-30B-A3B-Instruct"] = "Qwen3-Coder-30B-A3B-Instruct",
		}

		-- プロバイダを動的に生成
		for provider_key, model in pairs(sakura_models) do
			providers[provider_key] = vim.tbl_extend("force", sakura_base, { model = model })
		end

		-- Gemini
		providers.gemini = {
			api_key_name = "GEMINI_API_KEY",
			endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
			model = "gemini-2.5-flash",
			disabled_tools = DISABLED_TOOLS,
			extra_request_body = {
				temperature = temperature_param,
			},
		}

		-- LM Studio
		providers.lmstudio = {
			__inherited_from = 'openai',
			endpoint = vim.env.LMSTUDIO_API_URL or 'http://localhost:1234/v1',
			api_key_name = '',
			model = 'qwen3-coder-30b-a3b-instruct',
			-- すべてのツールを無効化
			disabled_tools = true,
			extra_request_body = {
				temperature = temperature_param,
				max_tokens = 8192,
			},
		}

		return providers
	end)(),

	-- 各種自動設定
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
			height = 17,
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
