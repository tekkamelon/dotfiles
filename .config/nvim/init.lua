-- init.lua

-- ====== 標準プラグインの読込停止 ======
-- "vim.g"をテーブルで設定
local options = {

	did_install_default_menus = 1,
	did_load_filetypes = 1,
	did_load_ftplugin = 1,
	loaded_2html_plugin = 1,
	loaded_getscript = 1,
	loaded_getscriptPlugin = 1,
	loaded_gzip = 1,
	loaded_man = 1,
	loaded_matchit = 1,
	loaded_netrw = 1,
	loaded_netrwFileHandlers = 1,
	loaded_netrwPlugin = 1,
	loaded_netrwSettings = 1,
	loaded_remote_plugins = 1,
	loaded_rrhelper = 1,
	loaded_shada_plugin = 1,
	loaded_spellfile_plugin = 1,
	loaded_tarPlugin = 1,
	loaded_tutor_mode_plugin = 1,
	loaded_vimball = 1,
	loaded_vimballPlugin = 1,
	loaded_zipPlugin = 1,
	skip_loading_mswin = 1,

}

-- "options"内の左辺を"let",右辺を"status"にそれぞれ代入しループ
for let, status in pairs(options) do

  vim.g[let] = status

end
-- ====== 標準プラグインの読込停止ここまで ======


--  ====== 拡張子ごとのfiletypeの設定 ======
-- *.cgiの場合
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.cgi' , command = 'set filetype=sh',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '*.cgi' , command = 'set filetype=sh',})

-- *.scadの場合
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.scad' , command = 'set filetype=openscad',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '*.scad' , command = 'set filetype=openscad',})

-- 各種設定ファイル
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*conf*' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '*conf*' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '.*rc' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '.*rc' , command = 'set filetype=conf',})

-- シェルの設定ファイル
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '.*shrc' , command = 'set filetype=sh',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '.*shrc' , command = 'set filetype=sh',})
--  ====== 拡張子ごとのfiletypeの設定ここまで ======


-- ビジュアルモード時に"$"で改行を含めないようにする
vim.keymap.set('v' , '$' , 'g_' , {remap = true})


-- ====== vim.optの設定 ======
-- "vim.opt"をテーブルで設定
local options = {

	-- 24bitカラーを有効 
	termguicolors = true,

	-- 背景色をダークモードに設定
	background = 'dark',

	-- 行番号を表示
	number = true,

	-- tabの幅を4に設定
	tabstop = 4,
	shiftwidth = 4,

	-- 分割方向を下と右に設定
	splitbelow = true,
	splitright = true,

	-- swapファイルを別ディレクトリに作成
	directory = '/tmp',

	-- カーソルラインを有効
	cursorline = true,

}

-- "options"内の左辺を"set",右辺を"str"にそれぞれ代入しループ
for set, str in pairs(options) do

  vim.opt[set] = str

end
-- ====== vim.optの設定ここまで ======


-- ====== ホスト名ごとでの処理の分岐 ======
-- ホスト名を確認"pop-os"の場合は真,そうでない場合は偽
if vim.fn.hostname() == "pop-os" then

	-- 真の場合はカラースキームを"iceberg"に設定
	vim.cmd([[colorscheme iceberg]])

-- 偽の場合はホスト名を確認,"pcg-2c7n"の場合は真,そうでない場合は偽
elseif vim.fn.hostname() == "pcg-2c7n" then

	-- 真の場合はカラースキームを"elflord"に設定
	vim.cmd([[colorscheme elflord]])

	-- 24bitカラーを無効
	vim.opt.termguicolors = false 

else

	-- 偽の場合はカラースキームを"industry"に設定
	vim.cmd([[colorscheme industry]])

end
-- ====== ホスト名ごとでの処理の分岐の終了 ======


-- ヤンクした範囲のハイライト,ビジュアルモード時にオフ
vim.cmd([[

	au TextYankPost * silent! lua vim.highlight.on_yank {higroup = "IncSearch", timeout = 700 , on_visual = false}

]])


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

-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then

	-- 真の場合は"vscode-neovim_set"の読み込み
	require('vscode-neovim_set')

else

	-- 偽の場合のキーマップ
	-- 保存,終了
	vim.keymap.set('n' , '<leader>w' , ':w<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>W' , ':wq<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>q' , ':q<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>Q' , ':q!<CR>' , {noremap = true})

	-- バッファの切り替え
	vim.keymap.set('n' , '<leader>j' , ':bprev<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>k' , ':bnext<CR>' , {noremap = true})

end
-- ====== leaderの設定ここまで ====== 


-- ====== プラグインの設定 ======
-- ====== Jetpackの設定 ======
vim.cmd('packadd vim-jetpack')

require('jetpack.paq'){

	{'tani/vim-jetpack' , opt = 1},

	-- キャッシュなどの高速化
	'lewis6991/impatient.nvim',
	'nathom/filetype.nvim',

	-- vim script製プラグイン
	'unblevable/quick-scope',
	'lambdalisue/fern.vim',
	'lambdalisue/fern-hijack.vim',
	'thinca/vim-partedit',
	'haya14busa/vim-edgemotion',

	-- lua製プラグイン
	'ojroques/nvim-hardline',
	'akinsho/toggleterm.nvim',
	'nvim-lua/plenary.nvim',
	'nvim-telescope/telescope.nvim',
	'glacambre/firenvim',

	-- mini.nvimのコンポーネント
	'echasnovski/mini.pairs',
	'echasnovski/mini.completion',
	'echasnovski/mini.comment',
	'echasnovski/mini.surround',
	'echasnovski/mini.jump2d',

	-- lspの設定
	'neovim/nvim-lspconfig',
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',

}
-- ====== Jetpackの設定ここまで ======


-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then

	-- 偽の場合は"vscode-neovim_plug"を読込
	require('vscode-neovim_plug')

else

	-- 真の場合はプラグインの読込
	-- impatientの設定
	require'impatient'.enable_profile()


	-- ====== quick-scopeの設定 ======
	-- ハイライトの色を設定
	vim.cmd([[

		highlight QuickScopePrimary guifg = 'red' gui = underline ctermfg = 199 cterm = underline
		highlight QuickScopeSecondary guifg = 'orange' gui = underline ctermfg = 129 cterm = underline

	]])
	-- ====== quick-scopeの設定ここまで ======


	-- ====== fernの設定 ====== 
	-- カレントディレクトリからサイドバー形式で開く
	vim.keymap.set('n' , '<C-n>' , ':Fern . -reveal=% -drawer -toggle -width=30<CR>' , {noremap = true})

	-- 行番号を非表示
	vim.cmd('autocmd FileType fern setlocal norelativenumber | setlocal nonumber')
	-- ====== fernの設定ここまで ====== 


	-- vim-parteditの設定
	-- ビジュアルモード時にleader+eでexモードのコマンドを表示
	vim.keymap.set('v' , '<leader>e' , ':Partedit -opener new -filetype ' , {noremap = true})


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


	-- ====== hardlineの設定 ======
	require('hardline').setup{

		-- バッファラインの表示
		bufferline = true,

		-- テーマの設定
		theme = 'one',

		sections = {
			
			-- 現在のモード
			{class = 'mode' , item = require('hardline.parts.mode').get_item},

			-- ファイルの種類
			{class = 'high' , item = require('hardline.parts.filetype').get_item, hide = 60},

			-- カレントバッファのパス
			{class = 'med' , item = require('hardline.parts.filename').get_item},
			
			-- セパレーター
			{class = 'med' , item = '%='},

			-- カレント行の位置
			{class = 'low' , item = require('hardline.parts.line').get_item},

		}

	}
	-- ====== hardlineの設定ここまで ======


	-- ====== telescopeの設定 =======
	require("telescope").setup{}

	-- leader+ffで隠しファイルを含めず,fhで含めて検索
	vim.keymap.set('n' , '<leader>ff' , ':Telescope find_files hidden=false previewer=false theme=get_dropdown<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>fh' , ':Telescope find_files hidden=true previewer=false theme=get_dropdown<CR>' , {noremap = true})

	-- leader+fbでバッファを検索
	vim.keymap.set('n' , '<leader>fb' , ':Telescope buffers previewer=false theme=get_dropdown<CR>' , {noremap = true})

	-- leader+frでレジスタ一覧を検索
	vim.keymap.set('n' , '<leader>fr' , ':Telescope registers<CR>' , {noremap = true})

	-- leader+fgでファイル内文字列を検索,"$ sudo apt install ripgrep -y"で使用可能
	vim.keymap.set('n' , '<leader>fg' , ':Telescope live_grep hidden=true previewer=true theme=get_dropdown<CR>' , {noremap = true})
	-- ====== telescopeの設定ここまで =======


	-- ====== firenvimの設定 =======
	-- ブラウザ側のfirenvimが起動していれば真,それ以外で偽
	if vim.g.started_by_firenvim == true then

		-- 真の場合はfirenvimを起動
		vim.o.laststatus = 0

	else

		-- 偽の場合は起動しない
		vim.o.laststatus = 2

	end
	-- ====== firenvimの設定ここまで =======


	-- ====== toggletermの設定 ======
	require("toggleterm").setup{}

	-- leader+ttで下方,tvで右側,tfでフロートウィンドウのターミナルのトグル
	vim.keymap.set('n' , '<leader>tt' , ':ToggleTerm size=20 direction=horizontal<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>tv' , ':ToggleTerm size=60 direction=vertical<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>tf' , ':ToggleTerm direction=float<CR>' , {noremap = true})

	-- ノーマルモード時にleader+tsで現在カーソルのある行を,ビジュアルモード時にleader+tで選択範囲をターミナルに送る
	vim.keymap.set('n' , '<leader>ts' , ':ToggleTermSendCurrentLine<CR>' , {noremap = true})
	vim.keymap.set('v' , '<leader>t' , ':ToggleTermSendVisualSelection<CR>' , {noremap = true})

	-- leader+gでコメントアウト
	vim.keymap.set('n' , '<leader>g' , 'gcc' , {remap = true})
	vim.keymap.set('v' , '<leader>g' , 'gc' , {remap = true})
	-- ====== toggletermの設定ここまで ======


	-- ====== mini.pairsの設定 ======
	require('mini.pairs').setup{}

	-- "<>"でのペアを設定
	MiniPairs.map('i', '<', { action = 'open', pair = '<>', neigh_pattern = '\r.', register = { cr = false } })
	MiniPairs.map('i', '>', { action = 'close', pair = '<>', register = { cr = false } })
	-- ====== mini.pairsの設定ここまで ======


	-- mini.completionの設定
	require('mini.completion').setup{}


	-- mini.commentの設定
	require('mini.comment').setup{

		-- 空白行を無視
		options = {ignore_blank_line = true,},

	}


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


	-- ====== mason*の設定 =======
	require('mason').setup{}

	-- ローカル関数の定義
	local lspconfig = require('lspconfig')

	require('mason-lspconfig').setup_handlers{

		function(server_name)

			lspconfig[server_name].setup{

			capabilities = capabilities,

		}

		end,

	}
	-- ====== mason*の設定ここまで =======

end
-- ====== プラグインの設定ここまで ======
