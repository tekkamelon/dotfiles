-- vscode-neovim_plug.lua

-- ====== quick-scopeの設定 ======
-- ハイライトの色を設定
vim.cmd([[

	highlight QuickScopePrimary guifg = 'red' gui = underline ctermfg = 199 cterm = underline
	highlight QuickScopeSecondary guifg = 'orange' gui = underline ctermfg = 129 cterm = underline

]])


-- ====== vim-edgemotionの設定 ======
-- ctrl+j,ctrl+下キーで1つ下のコードブロックへ
vim.keymap.set('n' , '<C-j>' , '<Plug>(edgemotion-j)' , {noremap = true})
vim.keymap.set('v' , '<C-j>' , '<Plug>(edgemotion-j)' , {noremap = true})
vim.keymap.set('n' , '<C-Down>' , '<Plug>(edgemotion-j)' , {noremap = true})
vim.keymap.set('v' , '<C-Down>' , '<Plug>(edgemotion-j)' , {noremap = true})

-- ctrl+k,上キーで1つ上のコードブロックへ
vim.keymap.set('n' , '<C-k>' , '<Plug>(edgemotion-k)' , {noremap = true})
vim.keymap.set('v' , '<C-k>' , '<Plug>(edgemotion-k)' , {noremap = true})
vim.keymap.set('n' , '<C-Up>' , '<Plug>(edgemotion-k)' , {noremap = true})
vim.keymap.set('v' , '<C-Up>' , '<Plug>(edgemotion-k)' , {noremap = true})
-- ====== vim-edgemotionの設定ここまで ======


-- ====== mini.surroundの設定 ====== 
require('mini.surround').setup{

	-- キーマッピングの設定
	mappings = {

		add = 'ca',
		delete = 'cd',
		find = 'cf',
		find_left = 'cF',
		highlight = 'ch',
		replace = 'cr',
		update_n_lines = 'cn',

		suffix_last ='l',
		suffix_next = 'n',

	},

	-- 矩形選択時に各行を囲む
	respect_selection_type = true,

}
-- ====== mini.surroundの設定ここまで ====== 


-- ====== mini.jump2dの設定 ======
require('mini.jump2d').setup{

	-- ラベルに使う文字の設定
	labels = 'qwertyuiophjklasdfg',

	view = {

		-- 使用時にハイライトの無い部分を暗くする
		dim = true,

	},

	mappings = {

		-- leader+hで起動
		start_jumping = '<leader>h',

	},

}
-- ====== mini.jump2dの設定ここまで ======
