-- agentic.lua
-- Neovim >= 0.11.0
-- carlos-algms/agentic.nvim の設定 (trial/agentic-nvim)
-- avante.nvim からの移行試用: shortcuts は持たない

if vim.g.vscode then return end

-- AVANTE_PROVIDER (avante 式の名前) を agentic 式の名前に読み替え
local avante_to_agentic = {
	opencode = "opencode-acp",
	["qwen-code"] = "qwen-code-acp",
	goose = "goose-acp",
	cline = "cline-acp",
	openhands = "openhands-acp",
	kilocode = "kilocode-acp",
	codex = "codex-acp",
	zeroclaw = "zeroclaw-acp",
	hermes = "hermes-acp",
	grok = "grok-acp",
	pi = "pi-acp",
	dsh = "dsh-acp",
}

local provider_name = avante_to_agentic[vim.env.AVANTE_PROVIDER or ""]
if not provider_name then
	provider_name = "pi-acp"
	vim.notify("AVANTE_PROVIDER が未設定のため pi-acp を使用", vim.log.levels.WARN)
else
	-- 起動時にプロバイダを通知
	vim.notify("provider: " .. provider_name, vim.log.levels.INFO)
end

require("agentic").setup({
	-- デフォルトのプロバイダ
	provider = provider_name,

	-- CLIコーディングエージェント
	-- builtin にない ACP 互換プロバイダを追加 (avante.lua から移植)
	acp_providers = {
		["qwen-code-acp"] = {
			name = "Qwen Code ACP",
			command = "qwen",
			args = { "--acp" },
		},
		["openhands-acp"] = {
			name = "OpenHands ACP",
			command = "openhands",
			args = { "acp" },
		},
		["kilocode-acp"] = {
			name = "Kilo Code ACP",
			command = "kilocode",
			args = { "acp" },
		},
		["codex-acp"] = {
			name = "Codex ACP",
			command = "npx",
			args = { "@zed-industries/codex-acp" },
		},
		["zeroclaw-acp"] = {
			name = "ZeroClaw ACP",
			command = "zeroclaw",
			args = { "acp" },
		},
		["hermes-acp"] = {
			name = "Hermes ACP",
			command = "hermes",
			args = { "acp" },
		},
		["grok-acp"] = {
			name = "Grok ACP",
			command = "grok",
			args = { "agent", "stdio" },
		},
		-- `.dsh/profiles/acp/cordis.patch.yml`で`- id: acp`を定義しておく
		["dsh-acp"] = {
			name = "dsh ACP",
			command = "dsh",
			args = { "--profile", "acp" },
		},
		-- goose は API キーを環境変数で渡す (avante.lua から移植)
		["goose-acp"] = {
			env = {
				NVIDIA_API_KEY = vim.env.NVIDIA_API_KEY,
				OPENROUTER_API_KEY = vim.env.OPENROUTER_API_KEY,
				SAKURA_API_KEY = vim.env.SAKURA_API_KEY,
				CUSTOM_SAKURA_API_KEY = vim.env.SAKURA_API_KEY,
				-- MCPサーバー用APIキー
				BRAVE_API_KEY = vim.env.BRAVE_API_KEY,
			},
		},
		-- pi は builtin の pi-acp を使用
		-- 事前に pi 側で `/login` を実行し `~/.pi/agent/auth.json` を確認
	},

	windows = {
		position = "right",
		-- avante と同じ幅
		width = 37,
		input = {
			-- avante と同じ高さ
			height = 17,
		},
	},
})

-- widget 外から model 切り替えを開く補助
-- widget 内の正規操作は `<localLeader>m`
local M = {}

M.pick_model = function()
	require("agentic").open()
	local leader = vim.g.maplocalleader or "\\"
	vim.schedule(function()
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes(leader .. "m", true, false, true),
			"m",
			false
		)
	end)
end

return M
