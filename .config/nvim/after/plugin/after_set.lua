-- after_set.lua
-- プラグインの起動後に読込


-- 改行時の自動コメントアウトをoff
vim.api.nvim_create_autocmd('FileType', { pattern = '*', command = 'setlocal formatoptions-=ro', })

-- カーソルラインをアンダーラインに設定
vim.api.nvim_set_hl(0, 'CursorLine', { underline = true })

-- カラースキームごとのポップアップメニューの設定
local colorscheme_settings = {

	iceberg = {

		PmenuSel = { fg = '#2f3234', bg = '#8389a3' },
		Pmenu = { fg = '#FFFFFF', bg = '#2f3234' }

	},

	industry = {

		PmenuSel = { fg = '#2f3234', bg = '#00aaaa' },
		Pmenu = { fg = '#FFFFFF', bg = '#000000' }

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

-- ハイライト設定をテーブルで一括管理
local highlight_groups = {
	-- eyelinerの設定
	EyelinerPrimary = { fg = 'red', bold = true, underline = true },
	EyelinerSecondary = { fg = 'orange', bold = true, underline = true },

	-- mini.statuslineの設定
	MiniStatuslineModeNormal = { fg = 'black', bg = '#b8d200', bold = true, underline = true },
	MiniStatuslineModeInsert = { fg = 'white', bg = '#0981D1', bold = true, underline = true },
	MiniStatuslineModeVisual = { fg = 'white', bg = 'darkorange', bold = true, underline = true },
	MiniStatuslineModeCommand = { fg = 'white', bg = '#00aaaa', bold = true, underline = true },
	-- LSPなどの表示
	MiniStatuslineDevinfo = { fg = 'white', bg = 'purple', bold = true, underline = false },

	-- mini.tablineの設定
	MiniTablineCurrent = { fg = 'black', bg = '#b8d200', bold = true, underline = true },
	MiniTablineVisible = { fg = 'white', bg = '#2e3234', bold = true, underline = false },
	MiniTablineHidden = { fg = 'grey', bg = '#2e3234', bold = false, underline = false },
	MiniTablineModifiedCurrent = { fg = 'white', bg = 'red', bold = true, underline = true },
	MiniTablineModifiedVisible = { fg = 'orange', bg = '#2e3234', bold = true, underline = true },
	MiniTablineModifiedHidden = { fg = 'yellow', bg = '#2e3234', bold = false, underline = true },
	MiniStatuslineModeOther = { fg = 'white', bg = 'black', bold = true, underline = false },

	-- avanteの設定
	-- ファイル,コード選択のタイトル
	AvanteSubtitle = { fg = '#2e3234', bg = '#00aaaa', bold = true, underline = true },
	-- プロンプトのタイトル
	AvanteThirdTitle = { fg = '#2e3234', bg = '#b8d200', bold = true, underline = true },
	-- ビジュアルモード時のプロンプトの入力欄
	AvantePromptInput = { fg = 'white', bg = '#2e3234', bold = true, underline = false },
	-- ビジュアルモード時のヒント
	AvanteInlineHint = { fg = 'lightgrey', bg = 'black', bold = false, underline = false },
}

-- テーブルからハイライトを一括設定
for group, colors in pairs(highlight_groups) do
	vim.api.nvim_set_hl(0, group, colors)
end

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
