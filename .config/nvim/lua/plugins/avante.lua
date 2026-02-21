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

-- 環境変数からプロバイダ名を取得,なければ"openrouter/glm-4.5-air:free"を使用
local provider_name = vim.env.AVANTE_PROVIDER or "openrouter/glm-4.5-air:free"

-- 環境変数でプロバイダを指定した場合,Avanteのキャッシュを削除して強制的に適用
if vim.env.AVANTE_PROVIDER then
	local avante_config_path = vim.fn.expand("~/.config/avante.nvim/config.json")
	if vim.fn.filereadable(avante_config_path) == 1 then
		vim.fn.delete(avante_config_path)
	end
end

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

		-- OAuth認証必須
		["qwen-code"] = {
			command = "qwen",
			args = { "--acp" },
		},

		["goose"] = {
			command = "goose",
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
			["openrouter/step-3.5-flash-free"] = "stepfun/step-3.5-flash:free",
			["openrouter/glm-4.5-air:free"] = 'z-ai/glm-4.5-air:free',
			["openrouter/glm-4.7"] = 'z-ai/glm-4.7',
			["openrouter/grok-4.1-fast"] = 'x-ai/grok-4.1-fast',
			["openrouter/grok-code-fast-1"] = 'x-ai/grok-code-fast-1',
			["openrouter/qwen3-coder-next"] = 'qwen/qwen3-coder-next',
			["openrouter/qwen3-vl-235b-a22b-thinking"] = 'qwen/qwen3-vl-235b-a22b-thinking',
		}

		-- OpenRouterプロバイダを動的に生成
		for provider_key, model in pairs(openrouter_models) do
			providers[provider_key] = vim.tbl_extend("force", openrouter_base, { model = model })
		end

		-- Gemini
		providers.gemini = {
			api_key_name = "GEMINI_API_KEY",
			endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
			model = "gemini-2.5-flash",
			disable_tools = DISABLED_TOOLS,
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
			disable_tools = true,
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
