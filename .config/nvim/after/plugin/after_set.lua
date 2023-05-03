-- after_set.lua
-- プラグインの起動後に読込

-- ====== 共通の設定 ======
-- ポップアップメニューの設定
vim.api.nvim_set_hl(0, 'Pmenu' , { guifg=white , guibg=grey})

-- 改行時の自動コメントアウトをoff
vim.api.nvim_create_autocmd('FileType' , {pattern = '*' , command = 'setlocal formatoptions-=ro',})

-- カーソルラインをアンダーラインに設定
vim.api.nvim_set_hl(0, 'CursorLine' , { underline = true })
-- ====== 共通の設定ここまで ======


-- ポップアップメニューの設定,ホスト名を確認,"pop-os"であれ真,それ以外で偽
if vim.fn.hostname() == "pop-os" then

	-- 真の場合の設定
	vim.cmd([[highlight PmenuSel guifg=#2f3234 guibg=#8389a3]])

else

	-- 偽の場合の設定
	vim.cmd([[highlight PmenuSel guifg=#2f3234 guibg=#00aaaa]])

end
