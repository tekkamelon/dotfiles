-- init.lua

-- 標準プラグインの読込の停止
vim.cmd([[

	let g:did_install_default_menus = 1
	let g:loaded_2html_plugin       = 1
	let g:loaded_gzip               = 1
	let g:loaded_man                = 1
	let g:loaded_matchit            = 1
	let g:loaded_matchparen         = 1
	let g:loaded_shada_plugin       = 1
	let g:loaded_spellfile_plugin   = 1
	let g:loaded_tarPlugin          = 1
	let g:loaded_tutor_mode_plugin  = 1
	let g:loaded_zipPlugin          = 1
	let g:skip_loading_mswin        = 1

]])

-- 24bitカラーを有効
vim.opt.termguicolors = true

-- 背景色をダークモードに設定
vim.opt.background = 'dark'

-- 行番号を表示
vim.opt.number = true

-- tabの幅を4に設定
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- カーソルラインを表示
vim.opt.cursorline = true

-- ビジュアルモード時に"$"で改行を含めないようにする
vim.keymap.set('v' , '$' , 'g_' , {remap = true})

-- vim script
vim.cmd([[

	" カラースキームを設定
	" colorscheme ron 
	colorscheme industry 

	" 一度カーソルラインをリセット
	highlight clear CursorLine

	" ターミナル起動時に行番号を非表示
	autocmd TermOpen * setlocal norelativenumber
	autocmd TermOpen * setlocal nonumber

	" ターミナルの設定
	" "Bterm"コマンドの設定,ターミナルを下画面に高さを7行分下げた状態で起動
	command! -nargs=* Bterm split | resize -7 | terminal <args>

	" "Vterm"の設定,ターミナルを右半分に起動
	command! -nargs=* Vterm vsplit | terminal <args>

	" ヤンクした範囲のハイライト,ビジュアルモード時にオフ
	au TextYankPost * silent! lua vim.highlight.on_yank {higroup = "IncSearch", timeout = 700 , on_visual = false}

]])


-- カーソルラインをアンダーラインに設定
vim.api.nvim_set_hl(0, 'CursorLine' , { underline = true })

-- ターミナルノーマルモードへの移行
vim.keymap.set('t', '<C-w><C-n>' , [[<C-\><C-n>]] , {noremap = true})

-- swapファイルを別ディレクトリに作成
vim.opt.directory = '/tmp'

-- 分割方向を下と右
vim.opt.splitbelow = true
vim.opt.splitright= true

-- ====== leaderの設定 ====== 
-- leaderをspaceに設定  
vim.g.mapleader = " "

-- 保存,終了
vim.api.nvim_set_keymap('n' , '<leader>w' , ':w<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>W' , ':wq<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>q' , ':q<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>Q' , ':q!<CR>' , {noremap = true})

-- バッファの切り替え
vim.api.nvim_set_keymap('n' , '<leader>j' , ':bprev<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>k' , ':bnext<CR>' , {noremap = true})
-- ====== leaderの設定ここまで ====== 


-- ====== プラグインの設定 ======
-- Jetpackの設定
vim.cmd('packadd vim-jetpack')

require('jetpack.paq'){

	{'tani/vim-jetpack', opt = 1},
	'LunarWatcher/auto-pairs',
	'unblevable/quick-scope',
	'lambdalisue/fern.vim',
	'ojroques/nvim-hardline',
	'numToStr/Comment.nvim',
	'thinca/vim-partedit',
	'akinsho/toggleterm.nvim',
	'haya14busa/vim-edgemotion',

	-- neovim 0.7.0から
	-- " telescope.nvimの依存関係
	'nvim-lua/plenary.nvim',
	'nvim-telescope/telescope.nvim',

}

-- ====== quick-scopeの設定 ======
-- ハイライトの色を設定
vim.cmd([[

	highlight QuickScopePrimary guifg='red' gui=underline ctermfg=199 cterm=underline
	highlight QuickScopeSecondary guifg='orange' gui=underline ctermfg=129 cterm=underline

]])
-- ====== quick-scopeの設定ここまで ======


-- ====== fernの設定 ====== 
-- カレントディレクトリからサイドバー形式で開く
vim.api.nvim_set_keymap('n' , '<C-n>' , ':Fern . -reveal=% -drawer -toggle -width=30<CR>' , {noremap = true})

-- 行番号を非表示
vim.cmd([[

	autocmd FileType fern setlocal norelativenumber | setlocal nonumber

]])
-- ====== fernの設定ここまで ====== 


-- ====== hardlineの設定 ======
require('hardline').setup{

	-- バッファラインの表示
	bufferline = true,

	-- テーマ
	theme = 'one',

	-- 表示するステータス,配色などの設定
	sections = {
		
		-- 現在のモード
		{class = 'mode', item = require('hardline.parts.mode').get_item},

		-- ファイル名の配色を"med"(中間)に設定
		{class = 'med', item = require('hardline.parts.filename').get_item},
    	'%<',
		{class = 'med', item = '%='},

		-- 現在の単語数
    	{class = 'low', item = require('hardline.parts.wordcount').get_item, hide = 100},

		-- ファイルの種類
		{class = 'high', item = require('hardline.parts.filetype').get_item, hide = 60},

		-- 行全体のパーセンテージ
    	{class = 'mode', item = require('hardline.parts.line').get_item},

	}

}
-- ====== hardlineの設定ここまで ======


-- Commentの設定
require('Comment').setup{}

-- vim-parteditの設定
-- ビジュアルモード時にleader+eでexモードのコマンドを表示
vim.api.nvim_set_keymap('v' , '<leader>e' , ':Partedit -opener new -filetype ' , {noremap = true})

-- ====== toggletermｎの設定 ======
require("toggleterm").setup{}

-- leader+ttで下方にターミナルのトグル
vim.api.nvim_set_keymap('n' , '<leader>tt' , ':ToggleTerm size=20 direction=horizontal<CR>' , {noremap = true})

-- leader+tvで右側にターミナルのトグル
vim.api.nvim_set_keymap('n' , '<leader>tv' , ':ToggleTerm size=60 direction=vertical<CR>' , {noremap = true})

-- leader+tfでフロートウィンドウでターミナルのトグル
vim.api.nvim_set_keymap('n' , '<leader>tf' , ':ToggleTerm direction=float<CR>' , {noremap = true})

-- ノーマルモード時にleader+tsで現在カーソルのある行をターミナルに送る
vim.api.nvim_set_keymap('n' , '<leader>ts' , ':ToggleTermSendCurrentLine<CR>' , {noremap = true})

-- ビジュアルモード時にleader+tで選択範囲をターミナルに送る
vim.api.nvim_set_keymap('v' , '<leader>t' , ':ToggleTermSendVisualSelection<CR>' , {noremap = true})

-- leader+gでコメントアウト
vim.keymap.set('n' , '<leader>g' , 'gcc' , {remap = true})
vim.keymap.set('v' , '<leader>g' , 'gc' , {remap = true})
-- ====== toggletermの設定ここまで ======


-- ====== vim-edgemotionの設定 ======

-- ctrl+jで1つ下のコードブロックへ
vim.api.nvim_set_keymap('n' , '<C-j>' , '<Plug>(edgemotion-j)' , {noremap = true})
vim.api.nvim_set_keymap('v' , '<C-j>' , '<Plug>(edgemotion-j)' , {noremap = true})

-- ctrl+kで1つ上のコードブロックへ
vim.api.nvim_set_keymap('n' , '<C-k>' , '<Plug>(edgemotion-k)' , {noremap = true})
vim.api.nvim_set_keymap('v' , '<C-k>' , '<Plug>(edgemotion-k)' , {noremap = true})
-- ====== vim-edgemotionの設定ここまで ======


-- ====== neovim 0.7.0から ======
-- telescopeの設定,プレビューをオフ
-- leader+ffでファイルを検索
vim.api.nvim_set_keymap('n' , '<leader>ff' , ':Telescope find_files hidden=false previewer=false theme=get_dropdown<CR>' , {noremap = true})

-- leader+fhで隠しファイルごと検索
vim.api.nvim_set_keymap('n' , '<leader>fh' , ':Telescope find_files hidden=true previewer=false theme=get_dropdown<CR>' , {noremap = true})

-- leader+bでバッファを検索
vim.api.nvim_set_keymap('n' , '<leader>b' , ':Telescope buffers previewer=false theme=get_dropdown<CR>' , {noremap = true})
-- ====== プラグインの設定ここまで ======

