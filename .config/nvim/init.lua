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

-- カーソルラインの設定
vim.cmd([[
	
	" カラースキームを設定
	" colorscheme ron 
	colorscheme industry 

	" 一度カーソルラインをリセット
	hi clear CursorLine

	" カーソルラインをアンダーラインに設定
	hi CursorLine gui=underline cterm=underline

	" ターミナル起動時に行番号を非表示
	autocmd TermOpen * setlocal norelativenumber
	autocmd TermOpen * setlocal nonumber

	" fernの設定
	" 行番号を非表示
	autocmd FileType fern setlocal norelativenumber | setlocal nonumber

	" ターミナルの設定
	" "Bterm"コマンドの設定,ターミナルを下画面に高さを7行分下げた状態で起動
	command! -nargs=* Bterm split | resize -7 | terminal <args>

	" "Vterm"の設定,ターミナルを右半分に起動
	command! -nargs=* Vterm vsplit | terminal <args>

]])

-- ターミナルノーマルモードへの移行
vim.keymap.set('t', '<C-w><C-n>' , [[<C-\><C-n>]] , {noremap=true})

-- swapファイルを別ディレクトリに作成
vim.opt.directory = '/tmp'

-- 分割方向を下と右
vim.opt.splitbelow = true
vim.opt.splitright= true

-- ====== leaderをspaceに設定 ====== 
vim.g.mapleader = " "

-- 保存,終了
vim.api.nvim_set_keymap('n' , '<leader>w' , ':w<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>W' , ':wq<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>q' , ':q<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>Q' , ':q!<CR>' , {noremap = true})

-- バッファの切り替え
vim.api.nvim_set_keymap('n' , '<leader>j' , ':bprev<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>k' , ':bnext<CR>' , {noremap = true})

-- ターミナルの起動
vim.api.nvim_set_keymap('n' , '<leader>t' , ':Bterm<CR>' , {noremap = true})
vim.api.nvim_set_keymap('n' , '<leader>v' , ':Vterm<CR>' , {noremap = true})

-- ====== leaderの設定ここまで ====== 

-- ====== 以降プラグインの設定 ======
-- Jetpackの設定
vim.cmd('packadd vim-jetpack')

require('jetpack.paq'){

	{'tani/vim-jetpack', opt = 1},
	'LunarWatcher/auto-pairs',
	'unblevable/quick-scope',
	'lambdalisue/fern.vim',
	'ojroques/nvim-hardline',
	'ap/vim-buftabline',
	'numToStr/Comment.nvim',

	-- " 以下の機能は0.7.0から
	-- " telescope.nvimの依存関係
	'nvim-lua/plenary.nvim',
	'nvim-telescope/telescope.nvim',

}

vim.cmd([[

	" quick-scopeの設定
	" ハイライトの色を設定
	highlight QuickScopePrimary guifg='red' gui=underline ctermfg=199 cterm=underline
	highlight QuickScopeSecondary guifg='orange' gui=underline ctermfg=129 cterm=underline

]])

-- hardlineの設定
require('hardline').setup {}

-- Commentの設定
require('Comment').setup {}

-- fernの設定
-- カレントディレクトリからサイドバー形式で開く
vim.api.nvim_set_keymap('n' , '<C-n>' , ':Fern . -reveal=% -drawer -toggle -width=30<CR>' , {noremap = true})

-- Commentの設定
vim.keymap.set('n' , '<leader>g' , 'gcc' , {remap= true})
vim.keymap.set('v' , '<leader>g' , 'gc' , {remap= true})

-- telescopeの設定,プレビューをオフ
-- leader+fでファイルを検索
vim.api.nvim_set_keymap('n' , '<leader>f' , ':Telescope find_files hidden=false previewer=false theme=get_dropdown<CR>' , {noremap = true})

-- leader+Fで隠しファイルごと検索
vim.api.nvim_set_keymap('n' , '<leader>F' , ':Telescope find_files hidden=true previewer=false theme=get_dropdown<CR>' , {noremap = true})

-- leader+bでバッファを検索,プレビューをオフ
vim.api.nvim_set_keymap('n' , '<leader>b' , ':Telescope buffers previewer=false theme=get_dropdown<CR>' , {noremap = true})

