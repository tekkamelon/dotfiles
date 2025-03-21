-- treesitter.lua

-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('nvim-treesitter.configs').setup{

		-- ハイライトを有効化
		highlight = {

			enable = true,

		},

	}

end

