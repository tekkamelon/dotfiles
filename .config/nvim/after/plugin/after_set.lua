-- after_set.lua
-- プラグインの起動後に読込

-- ポップアップメニューの設定,ホスト名を確認,"pop-os"であれ真,それ以外で偽
if vim.fn.hostname() == "pop-os" then

	-- 真の場合の設定
	vim.cmd([[
	
		highlight Pmenu guifg=#FFFFFF guibg=#2f3234

		highlight PmenuSel guifg=#2f3234 guibg=#8389a3

	]])

else

	-- 偽の場合の設定
	vim.cmd([[

		highlight Pmenu guifg=#FFFFFF guibg=#2f3234

		highlight PmenuSel guifg=#2f3234 guibg=#00aaaa

	]])

end

-- 改行時の自動コメントアウトをoff
vim.cmd([[au FileType * setlocal formatoptions-=ro]])
