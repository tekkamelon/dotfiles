-- set_keymap
-- プラグイン以外のキーマップの設定


-- ====== ターミナルの設定 ====== 
-- ターミナルノーマルモードへの移行
vim.keymap.set('t' , '<C-w><C-n>' , [[<C-\><C-n>]] , {noremap = true})

-- ターミナル起動時に行番号を非表示
vim.api.nvim_create_autocmd('TermOpen' , {pattern = '*' , command = 'setlocal norelativenumber',})
vim.api.nvim_create_autocmd('TermOpen' , {pattern = '*' , command = 'setlocal nonumber',})

-- "Bterm"コマンドの設定,ターミナルを下画面に高さを7行分下げた状態で起動
vim.api.nvim_create_user_command('Bterm' , 'split | resize -7 | terminal', { nargs = 0 })

-- "Vterm"の設定,ターミナルを右半分に起動
vim.api.nvim_create_user_command('Vterm' , 'vsplit | terminal', { nargs = 0 })
-- ====== ターミナルの設定ここまで ====== 


-- ====== leaderの設定 ====== 
-- leaderをspaceに設定  
vim.g.mapleader = " "

-- vscode-nvimから起動したときに無効
if not vim.g.vscode then

	-- 保存,終了
	vim.keymap.set('n' , '<leader>w' , ':w<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>W' , ':wq<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>q' , ':q<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>Q' , ':q!<CR>' , {noremap = true})

	-- バッファの切り替え
	vim.keymap.set('n' , '<leader>j' , ':bprev<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>k' , ':bnext<CR>' , {noremap = true})
end

-- vscode-nvimから起動したときのみ有効
if vim.g.vscode then

	-- 保存及び終了
	vim.cmd([[

		nnoremap <silent> <leader>w <Cmd>call VSCodeCall('workbench.action.files.save')<CR>
		nnoremap <silent> <leader>W <Cmd>call VSCodeCall('workbench.action.files.saveALL')<CR>
		nnoremap <silent> <leader>q <Cmd>call VSCodeCall('workbench.action.closeActiveEditor')<CR>
		nnoremap <silent> <leader>Q <Cmd>call VSCodeCall('workbench.action.closeAllEditors')<CR>
		
	]])

end
-- ====== leaderの設定ここまで ====== 

-- ビジュアルモード時に"$"で改行を含めないようにする
vim.keymap.set('v' , '$' , 'g_' , {remap = true})
