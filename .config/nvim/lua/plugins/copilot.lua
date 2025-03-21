-- copilot.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('copilot').setup{

		-- サジェストの設定
		suggestion = {

			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 75,

			-- キーマッピングの設定
			keymap = {

				accept = false,
				accept_word = "<C-s>",
				next = "<C-f>",
				prev = "<C-F>",
				dismiss = "<C-]>",

			},

		},

		-- ファイルタイプの設定
		filetype = {

			gitcommit = true,
			markdown = true,

		},

	}

end

