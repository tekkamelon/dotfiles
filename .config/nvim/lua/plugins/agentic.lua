-- agentic.lua
-- Neovim >= 0.11.0

if vim.g.vscode then return end

require('agentic').setup {

	provider = "claude-agent-acp",

	windows = {
		position = "right",
		width = 37,
	},
}