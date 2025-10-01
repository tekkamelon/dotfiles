-- mini.files,lua

if not vim.g.vscode then

	-- mini.filesのトグルの設定
	local MiniFiles = require('mini.files')
	local minifiles_toggle = function()

		-- ファイラが開いていれば真
		if not MiniFiles.close() then

			-- カレントバッファのディレクトリを表示
			MiniFiles.open(vim.api.nvim_buf_get_name(0))

		end

	end

	-- キーマップ設定
	vim.keymap.set('n', '<C-n>', minifiles_toggle, { desc = "Toggle mini.files" })

end
