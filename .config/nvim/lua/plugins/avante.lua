-- avante.lua
-- Neovim >= 0.11.0

if vim.g.vscode then return end

-- 環境変数からプロバイダ名を取得,なければ"qwen"を使用
local provider_name = vim.env.AVANTE_PROVIDER or "qwen"

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
