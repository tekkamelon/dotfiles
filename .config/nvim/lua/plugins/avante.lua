-- avante.lua
-- Neovim >= 0.11.0

if vim.g.vscode then return end

-- 環境変数からプロバイダ名を取得
local provider_name = vim.env.AVANTE_PROVIDER

-- 変数の値があればコマンドがあるかをチェック,なければエラー通知
if not provider_name then
	vim.notify("AVANTE_PROVIDER environment variable is not set", vim.log.levels.ERROR)
	return
else
	-- 起動時にプロバイダを通知
	vim.notify("provider: " .. provider_name, vim.log.levels.INFO)
end

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
				"--acp",
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
