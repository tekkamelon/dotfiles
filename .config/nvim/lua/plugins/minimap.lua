-- mini.mapの設定
-- markdownファイル時のみミニマップを表示

-- vscode-neovimから起動した場合は実行しない
if vim.g.vscode then return end
local minimap = require("mini.map")

minimap.setup({
	-- ウィンドウ設定
	window = {
		-- ミニマップの幅
		width = 15,
		-- 右側に表示
		side = "right",
		-- ウィンドウの透明度
		winblend = 0,
		-- カーソル行を追従しない(パフォーマンス向上)
		show_integration_count = false,
		-- スクロールバーを非表示
		scrollview = nil,
	},

	-- 表示に使用するシンボル
	symbols = {
		-- エンコードシンボル
		encode = minimap.gen_encode_symbols.dot("3x2"),
		-- スクロールライン
		scroll_line = "┃",
		-- スクロールビュー
		scroll_view = "",
	},

	-- ハイライト統合（デフォルトは無効）
	integrations = nil,
})

-- markdown以外のファイルに移動した場合はミニマップを閉じる
vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
	callback = function()
		if vim.bo.filetype ~= "markdown" then
			minimap.close()
		end
	end,
})
