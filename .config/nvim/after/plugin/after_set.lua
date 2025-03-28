-- after_set.lua
-- プラグインの起動後に読込


-- 改行時の自動コメントアウトをoff
vim.api.nvim_create_autocmd('FileType' , {pattern = '*' , command = 'setlocal formatoptions-=ro',})

-- カーソルラインをアンダーラインに設定
vim.api.nvim_set_hl(0, 'CursorLine' , { underline = true })

-- カラースキームごとのポップアップメニューの設定
local colorscheme_settings = {

    iceberg = {

		PmenuSel = {fg = '#2f3234', bg = '#8389a3'},
		Pmenu = {fg = '#FFFFFF', bg = '#2f3234'}

	},

    industry = {

		PmenuSel = {fg = '#2f3234', bg = '#00aaaa'},
		Pmenu = {fg = '#FFFFFF', bg = '#000000'}

	},

}

-- ローカル変数"colorscheme"に現在のカラースキームを代入"
local settings = colorscheme_settings[vim.g.colors_name]

	if settings then

	-- テーブルから現在のハイライトを呼び出す
    for group, colors in pairs(settings) do

        vim.api.nvim_set_hl(0, group, colors)

    end

end

-- eyelinerのハイライトの色を設定
vim.api.nvim_set_hl(0, 'EyelinerPrimary', {fg = 'red', bold = true, underline = true})
vim.api.nvim_set_hl(0, 'EyelinerSecondary', {fg = 'orange', bold = true, underline = true})

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
