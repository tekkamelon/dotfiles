-- after_set.lua
-- プラグインの起動後に読込


-- ポップアップメニューの設定
vim.api.nvim_set_hl(0, 'Pmenu',{ guifg=white , guibg=grey})

-- 改行時の自動コメントアウトをoff
vim.api.nvim_create_autocmd('FileType' , {pattern = '*' , command = 'setlocal formatoptions-=ro',})

-- カーソルラインをアンダーラインに設定
vim.api.nvim_set_hl(0, 'CursorLine' , { underline = true })

-- ローカル変数"colorscheme"に現在のカラースキームを代入"
local colorscheme = vim.g.colors_name

-- "colorscheme"が"iceberg"であれば真
if colorscheme == "iceberg" then

	vim.api.nvim_set_hl(0, 'PmenuSel',{ fg='#2f3234' , bg='#8389a3' })

-- "colorscheme"が"industry"であれば真
elseif colorscheme == "industry" then

	vim.api.nvim_set_hl(0, 'PmenuSel',{ fg='#2f3234' , bg='#00aaaa' })

	-- 特定の言語でハイライトしないようにする
	vim.treesitter.start = (function(wrapped)

		-- ラッパー関数
		return function(bufnr, lang)

			-- ローカル変数"ft"にバッファのファイルタイプを代入
			local ft = vim.fn.getbufvar(bufnr or vim.fn.bufnr(''), '&filetype')

			-- 除外する言語のリスト
			local check = (

				ft == 'help'
				or lang == 'bash'
				or lang == 'awk'
				or lang == 'html'

			)

			-- "check"が真であれば終了
			if check then

				return

			end

			wrapped(bufnr, lang)

		end

	end)(vim.treesitter.start)


end

-- eyelinerのハイライトの色を設定
vim.api.nvim_set_hl(0, 'EyelinerPrimary',{ fg='red', bold = true, underline = true })
vim.api.nvim_set_hl(0, 'EyelinerSecondary',{ fg='orange', bold = true, underline = true })

