-- light_init.lua

-- vim script
vim.cmd([[

	" 標準プラグインの読込の停止
	let g:did_install_default_menus = 1
	let g:did_load_ftplugin         = 1
	let g:loaded_2html_plugin       = 1
	let g:loaded_gzip               = 1
	let g:loaded_man                = 1
	let g:loaded_matchit            = 1
	let g:loaded_matchparen         = 1
	let g:loaded_remote_plugins     = 1
	let g:loaded_shada_plugin       = 1
	let g:loaded_spellfile_plugin   = 1
	let g:loaded_tarPlugin          = 1
	let g:loaded_tutor_mode_plugin  = 1
	let g:loaded_zipPlugin          = 1
	let g:skip_loading_mswin        = 1
	let g:loaded_rrhelper           = 1
	let g:loaded_vimball            = 1
	let g:loaded_vimballPlugin      = 1
	let g:loaded_getscript          = 1
	let g:loaded_getscriptPlugin    = 1
	let g:loaded_netrw              = 1
	let g:loaded_netrwPlugin        = 1
	let g:loaded_netrwSettings      = 1
	let g:loaded_netrwFileHandlers  = 1

	" ヤンクした範囲のハイライト,ビジュアルモード時にオフ
	au TextYankPost * silent! lua vim.highlight.on_yank {higroup = "IncSearch", timeout = 700 , on_visual = false}

]])

-- 行番号を表示
vim.opt.number = true

-- tabの幅を4に設定
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- 背景色をダークモードに設定
vim.opt.background = 'dark' 

-- ビジュアルモード時に"$"で改行を含めないようにする
vim.keymap.set('v' , '$' , 'g_' , {remap = true})

-- 分割方向を下と右に設定
vim.opt.splitbelow = true
vim.opt.splitright= true

-- swapファイルを別ディレクトリに作成
vim.opt.directory = '/tmp'

-- カーソルラインをアンダーラインに設定
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine' , { underline = true })


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
-- ====== ターミナルの設定の終了 ====== 


-- ====== leaderの設定 ====== 
-- leaderをspaceに設定  
vim.g.mapleader = " "

-- 保存,終了
vim.keymap.set('n' , '<leader>w' , ':w<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>W' , ':wq<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>q' , ':q<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>Q' , ':q!<CR>' , {noremap = true})

-- バッファの切り替え
vim.keymap.set('n' , '<leader>j' , ':bprev<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>k' , ':bnext<CR>' , {noremap = true})
-- ====== leaderの設定ここまで ====== 

