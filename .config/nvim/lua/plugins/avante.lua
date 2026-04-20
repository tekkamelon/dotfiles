-- avante.lua
-- Neovim >= 0.11.0

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
	--  avante起動前に`:lua require("avante.api").switch_provider("opencode")`などで切り替え可能
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
			args = {
				-- 必須オプション
				"--acp",
				-- 以下の部分はopenrouterを使用する場合
				"--auth-type", "openai",
				-- その他のAPIを利用する場合はURL部分を書き換える
				"--openai-base-url", "https://openrouter.ai/api/v1"
			},
			env = {
				-- ここも環境により書き換える
				OPENAI_API_KEY = os.getenv("OPENROUTER_API_KEY"),
			},
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

	shortcuts = shortcuts,
}
