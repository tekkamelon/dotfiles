-- copilot.lua
-- Neovim >= 0.11.0


-- vscodeから起動していなければ真
if not vim.g.vscode then
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
			AvanteInput = false,
			AvantePromptInput = false,
			AvanteSelectedFiles = false,
			AvanteSelectedCode = false,

		},

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
end

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
