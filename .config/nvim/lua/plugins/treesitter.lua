-- treesitter.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('nvim-treesitter.configs').setup{

		-- ハイライトを有効化
		highlight = {

			enable = true,

		},

	}

	-- カラースキームが"industry"であれば真
	if vim.g.colors_name == "industry" then

		local ts_start = vim.treesitter.start

		-- 除外するfiletype
		local excluded_types = {

			help = true,
			bash = true,
			awk = true,
			html = true

		}

		-- 関数"vim.treesitter.start"をオーバーライド
		vim.treesitter.start = function(bufnr, lang)

			-- 現在のfiletypeを取得
			local ft = vim.bo[bufnr or 0].filetype

			-- 除外するfiletypeが含まれていれば真
			if excluded_types[ft] or excluded_types[lang] then

				return

			end

			return ts_start(bufnr, lang)

		end

	end

end
