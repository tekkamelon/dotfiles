-- copilot.lua
-- Neovim >= 0.11.0


if vim.g.vscode then return end

require('copilot').setup {

	-- サジェストの設定
	suggestion = {

		enabled = true,
		auto_trigger = true,
		hide_during_completion = true,
		debounce = 50,

		-- キーマッピングの設定
		keymap = {

			accept = false,
			accept_word = "<C-s>",
			next = "<C-f>",
			prev = "<C-F>",
			dismiss = "<C-q>",

		},

	},

	-- ファイルタイプの設定
	filetype = {

		gitcommit = true,
		markdown = true,
		env = false,

	},

	-- AgenticInput は buftype = "nofile" のため, 既定の should_attach では拒否される
	should_attach = function(bufnr, bufname)
		if vim.bo[bufnr].filetype == "AgenticInput" then
			return true
		end
		local default_should_attach = require("copilot.config.should_attach").default
		return default_should_attach(bufnr, bufname)
	end,

	-- nesの設定
	-- "copilot-lsp"プラグインをインストール
	nes = {

		-- 有効化
		enabled = true,
		keymap = {

			accept_and_goto = "<C-i>",
			accept = false,
			dismiss = "<Esc>",

		},

	},

}

-- キーマップを設定
vim.keymap.set("i", '<Tab>', function()
	-- copilotがサジェストしていれば真
	if require("copilot.suggestion").is_visible() then
		require("copilot.suggestion").accept()
	else
		-- キーコードをneovimが解釈可能な形式に変換
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
	end
end, {
	-- コマンドラインへ表示しない
	silent = true,
}
)
