-- supermaven.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('supermaven-nvim').setup{

		-- キーマッピングの設定
		keymaps = {

			accept_suggestion = "<Tab>",
			clear_suggestion = "<C-q>",
			accept_word = "<C-s>",
			clear_word = "<C-y>",

		},

		color = {

			suggestion_color = "#FFFFFF",
			cterm = 244,

		},

		-- 除外するファイルのパターン
		ignore_filetypes = {

			-- "gitcommit",
			-- "markdown",
			"copilot-chat",

		},

	}

end

