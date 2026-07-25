-- agentic.lua
-- Neovim >= 0.11.0

if vim.g.vscode then return end

-- 環境変数からプロバイダ名を取得 (AGENTIC_PROVIDER を優先, 旧 AVANTE_PROVIDER も許容)
local provider_name = vim.env.AGENTIC_PROVIDER or vim.env.AVANTE_PROVIDER

-- avante 時代の短い名前を agentic のプロバイダキーへ対応付け
local provider_aliases = {
	opencode = "opencode-acp",
	goose = "goose-acp",
	cline = "cline-acp",
	codex = "codex-acp",
	["qwen-code"] = "qwen-code",
	openhands = "openhands",
	kilocode = "kilocode",
	zeroclaw = "zeroclaw",
	hermes = "hermes",
	grok = "grok",
}

if not provider_name then
	vim.notify("AGENTIC_PROVIDER (or AVANTE_PROVIDER) environment variable is not set", vim.log.levels.ERROR)
	return
end

provider_name = provider_aliases[provider_name] or provider_name
vim.notify("provider: " .. provider_name, vim.log.levels.INFO)

require("agentic").setup({
	provider = provider_name,

	-- CLIコーディングエージェント
	-- 組み込み以外は acp_providers で追加
	-- 切替: require("agentic").switch_provider() またはチャット内 <localLeader>s
	acp_providers = {
		-- 組み込み goose に環境変数を渡す
		["goose-acp"] = {
			env = {
				NVIDIA_API_KEY = vim.env.NVIDIA_API_KEY,
				OPENROUTER_API_KEY = vim.env.OPENROUTER_API_KEY,
				SAKURA_API_KEY = vim.env.SAKURA_API_KEY,
				CUSTOM_SAKURA_API_KEY = vim.env.SAKURA_API_KEY,
				BRAVE_API_KEY = vim.env.BRAVE_API_KEY,
			},
		},

		-- カスタム ACP プロバイダ (旧 avante 設定から移行)
		["qwen-code"] = {
			name = "Qwen Code",
			command = "qwen",
			args = { "--acp" },
		},

		["openhands"] = {
			name = "OpenHands",
			command = "openhands",
			args = { "acp" },
		},

		["kilocode"] = {
			name = "Kilo Code",
			command = "kilocode",
			args = { "acp" },
		},

		["zeroclaw"] = {
			name = "ZeroClaw",
			command = "zeroclaw",
			args = { "acp" },
		},

		["hermes"] = {
			name = "Hermes",
			command = "hermes",
			args = { "acp" },
		},

		["grok"] = {
			name = "Grok",
			command = "grok",
			args = {
				"agent",
				"stdio",
			},
		},
	},

	windows = {
		position = "right",
		-- 旧 avante の width = 37 に相当
		width = "37%",
		input = {
			height = 17,
		},
	},

	-- blink.cmp 側で補完するため, 組み込みの自動トリガーは無効化
	slash_commands = {
		auto_trigger = false,
	},
	file_picker = {
		auto_trigger = false,
	},
})
