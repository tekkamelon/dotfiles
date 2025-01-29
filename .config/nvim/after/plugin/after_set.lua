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

else

	vim.api.nvim_set_hl(0, 'PmenuSel',{ fg='#2f3234' , bg='#00aaaa' })

end

-- eyelinerのハイライトの色を設定
vim.api.nvim_set_hl(0, 'EyelinerPrimary',{ fg='red', bold = true, underline = true })
vim.api.nvim_set_hl(0, 'EyelinerSecondary',{ fg='orange', bold = true, underline = true })

