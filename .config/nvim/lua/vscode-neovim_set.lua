-- vscode-neovim_set.lua

-- "vscode-neovim"の場合のキーマップ
vim.cmd([[
	
	" 保存,終了
	nnoremap <silent> <leader>w :call VSCodeCall('workbench.action.files.save')<CR>
	nnoremap <silent> <leader>W :call VSCodeCall('workbench.action.files.saveALL')<CR>
	nnoremap <silent> <leader>q :call VSCodeCall('workbench.action.closeActiveEditor')<CR>
	nnoremap <silent> <leader>Q :call VSCodeCall('workbench.action.closeAllEditors')<CR>

	" バッファの切り替え
	nnoremap <silent> <leader>j :call VSCodeCall('workbench.action.previousEditor')<CR>
	nnoremap <silent> <leader>k :call VSCodeCall('workbench.action.nextEditor')<CR>

	" ファイルを開く
	nnoremap <silent> <leader>ff :call VSCodeCall('workbench.action.files.openFile')<CR>

	" フォルダーを開く
	nnoremap <silent> <leader>fh :call VSCodeCall('workbench.action.files.openFolder')<CR>

	" ターミナルのトグル
	nnoremap <silent> <leader>tt :call VSCodeCall('workbench.action.terminal.toggleTerminal')<CR>

	" コメントのトグル
	nnoremap <silent> <leader>g :call VSCodeCall('editor.action.commentLine')<CR>

]])

