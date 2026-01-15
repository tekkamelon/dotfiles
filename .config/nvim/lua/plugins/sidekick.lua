-- sidekick.lua
-- Neovim >= 0.11.2
-- Neovimプラグインsidekickの設定ファイル

if vim.g.vscode then return end

-- デフォルトのコーディングエージェント
local default_cli = "opencode"

require('sidekick').setup {
	nes = { enabled = false },
	cli = {
		win = {
			layout = "bottom",
			keys = {
				-- プロンプト挿入キー
				prompt = { "<leader>ap", "prompt", mode = "t", desc = "insert prompt or context" },
			},
		},

		-- ピッカーにtelescopeを使用
		picker = "telescope",
		mux = {
			-- tmuxをバックエンドとして使用
			backend = "tmux",
			enabled = true,
		},
	},
	keys = {
		{
			-- Tabキーで次の編集候補にジャンプまたは適用
			"<tab>",
			function()
				-- 次の編集候補があればジャンプ、なければ適用
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>"
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			-- CLIをトグル
			"<c-.>",
			function() require("sidekick.cli").toggle() end,
			desc = "Sidekick Toggle",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>aa",
			function() require("sidekick.cli").toggle({ name = default_cli, focus = true }) end,
			desc = "Sidekick Toggle CLI",
		},
		{
			-- CLIを選択
			"<leader>as",
			function() require("sidekick.cli").select() end,
			-- またはインストール済みツールのみを選択:
			-- require("sidekick.cli").select({ filter = { installed = true } })
			desc = "Select CLI",
		},
		{
			-- セッションを閉じる
			"<leader>ad",
			function() require("sidekick.cli").close() end,
			desc = "Detach a CLI Session",
		},
		{
			-- 現在のものを送信
			"<leader>at",
			function() require("sidekick.cli").send({ msg = "{this}" }) end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			-- ファイルを送信
			"<leader>af",
			function() require("sidekick.cli").send({ msg = "{file}" }) end,
			desc = "Send File",
		},
		{
			-- ビジュアル選択を送信
			"<leader>av",
			function() require("sidekick.cli").send({ msg = "{selection}" }) end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			-- プロンプトを選択
			"<leader>ap",
			function() require("sidekick.cli").prompt() end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
	},

}
