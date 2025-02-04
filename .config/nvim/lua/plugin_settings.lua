	-- plug_config.lua

-- プラグインのリスト
-- Jetpackの設定
vim.cmd('packadd vim-jetpack')

	require('jetpack.paq'){

		{'tani/vim-jetpack' , opt = 1},

		-- vim script製プラグイン
		'thinca/vim-partedit',
		'haya14busa/vim-edgemotion',
		'skanehira/jumpcursor.vim',

		-- lua製プラグイン
		'ojroques/nvim-hardline',
		'akinsho/toggleterm.nvim',
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope.nvim',
		'jinh0/eyeliner.nvim',
		'lewis6991/gitsigns.nvim',
		'zbirenbaum/copilot.lua',
		'CopilotC-Nvim/CopilotChat.nvim',
		'salkin-mada/openscad.nvim',
		'nvim-treesitter/nvim-treesitter',

		-- mini.nvimのモジュール
		'echasnovski/mini.pairs',
		'echasnovski/mini.completion',
		'echasnovski/mini.comment',
		'echasnovski/mini.surround',
		'echasnovski/mini.indentscope',
		'echasnovski/mini.icons',
		'echasnovski/mini.files',

		-- lspの設定
		'neovim/nvim-lspconfig',
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

	}

-- ローカル変数を宣言
local vim_keymap = vim.keymap.set
local options = { noremap = true }

-- vim-edgemotionの設定
-- -- ctrl+j,ctrl+下キーで1つ下のコードブロックへ
vim_keymap({'n' , 'v'} , '<C-j>' , '<Plug>(edgemotion-j)' , options)
vim_keymap({'n' , 'v'} , '<C-Down>' , '<Plug>(edgemotion-j)' , options)

-- ctrl+k,上キーで1つ上のコードブロックへ
vim_keymap({'n' , 'v'} , '<C-k>' , '<Plug>(edgemotion-k)' , options)
vim_keymap({'n' , 'v'} , '<C-Up>' , '<Plug>(edgemotion-k)' , options)

-- jumpcursorの設定
vim_keymap('n' , '<leader>h' , '<Plug>(jumpcursor-jump)' , options)

-- mini.commentの設定
require('mini.comment').setup{

	-- 空白行を無視
	options = {ignore_blank_line = true,},

}

-- leader+gでコメントアウト
vim_keymap({'n' , 'v'} , '<leader>g' , 'gcc' , {remap = true})

-- mini.surroundの設定 
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

-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then

	-- 真の場合は"vim-edgemotion"の設定の変更
	-- ctrl+l,上キーで1つ上のコードブロックへ
	vim_keymap({'n' , 'v'} , '<C-L>' , '<Plug>(edgemotion-k)' , options)

else

	-- vim-parteditの設定
	-- ビジュアルモード時にleader+eでexモードのコマンドを表示
	vim_keymap('v' , '<leader>e' , ':Partedit -opener new -filetype ' , options)

	-- hardlineの設定
	require('hardline').setup{

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
			{class = 'mode' , item = require('hardline.parts.line').get_item},

		}

	}

	-- telescopeの設定
	require("telescope").setup{}

	-- leader+ffで隠しファイルを含めず,fhで含めて検索
	vim_keymap('n' , '<leader>ff' , ':Telescope find_files hidden=false previewer=false theme=get_dropdown<CR>' , options)
	vim_keymap('n' , '<leader>fh' , ':Telescope find_files hidden=true previewer=false theme=get_dropdown<CR>' , options)

	-- leader+fbでバッファを検索
	vim_keymap('n' , '<leader>fb' , ':Telescope buffers previewer=false theme=get_dropdown<CR>' , options)

	-- leader+frでレジスタ一覧を検索
	vim_keymap('n' , '<leader>fr' , ':Telescope registers<CR>' , options)

	-- leader+fgでファイル内文字列を検索
	-- "$ sudo apt install ripgrep -y"で使用可能
	vim_keymap('n' , '<leader>fg' , ':Telescope live_grep hidden=true previewer=true theme=get_dropdown<CR>' , options)

	-- eyelinerの設定
	require('eyeliner').setup {

		highlight_on_key = false,

	}

	-- toggletermの設定
	require("toggleterm").setup{}

	-- leader+ttで下方,tvで右側,tfでフロートウィンドウのターミナルのトグル
	vim_keymap('n' , '<leader>tt' , ':ToggleTerm size=20 direction=horizontal<CR>' , options)
	vim_keymap('n' , '<leader>tv' , ':ToggleTerm size=60 direction=vertical<CR>' , options)
	vim_keymap('n' , '<leader>tf' , ':ToggleTerm direction=float<CR>' , options)

	-- ノーマルモード時にleader+tsで現在カーソルのある行を,ビジュアルモード時にleader+tで選択範囲をターミナルに送る
	vim_keymap('n' , '<leader>ts' , ':ToggleTermSendCurrentLine<CR>' , options)
	vim_keymap('v' , '<leader>t' , ':ToggleTermSendVisualLines<CR>' , options)

	-- mini.pairsの設定
	require('mini.pairs').setup{

		mappings = {

			-- "<>"の設定
			['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
			['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },

			-- "「」"の設定
			['「'] = { action = 'open', pair = '「」', neigh_pattern = '[^\\].' },
			['」'] = { action = 'close', pair = '「」', neigh_pattern = '[^\\].' },

		},

	}

	-- mini.completionの設定
	require('mini.completion').setup{}

	-- mini.indentscopeの設定
	require('mini.indentscope').setup{}

	-- mini.iconsの設定
	require('mini.icons').setup{

		-- アイコンのスタイルを"ascii"に設定
		style = 'ascii',

	}

	-- mini.filesの設定
	require('mini.files').setup{}
		
		-- minifiles_toggle関数を定義
		local minifiles_toggle = function(...)

			-- ファイラが開いていれば真
			if not MiniFiles.close() 

				-- カレントバッファのディレクトリを表示
				then MiniFiles.open(vim.api.nvim_buf_get_name(0))

			end

		end

		-- キーマッピングを設定
		vim_keymap('n', '<C-n>', minifiles_toggle, { noremap = true, silent = true })

	-- gitsignsの設定
	require('gitsigns').setup{

		signs = {
			
			change = { text = '>>' },
			
		},

		numhl = true,
		
	}

	-- copilot.luaの設定
	require('copilot').setup{

		-- サジェストの設定
		suggestion = {

			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 75,

			
			-- キーマッピングの設定
			keymap = {

				accept = "<C-s>",
				next = "<C-f>",
				prev = "<C-F>",
				dismiss = "<C-]>",

			},

		},

		-- ファイルタイプの設定
		filetype = {

			gitcommit = true,
			markdown = true,

		},

	}

	-- CopilotChatの設定
	require("CopilotChat").setup{

		-- チャット用のバッファの設定
		window = {

			layout = 'horizontal',
			width = 0.5,
			height = 0.4,

		},

	}

	-- leader+ccでチャット用バッファをトグル
	vim_keymap({'n' , 'v'} , '<leader>cc' , ':CopilotChatToggle<CR>' , { noremap = true })

	
	-- openscad.nvimの設定
	require('openscad').setup{}

	-- treesitterの設定
	require('nvim-treesitter.configs').setup{

		-- ハイライトを有効化
		highlight = {

			enable = true,

  		},

	}

	-- カラースキームが"industry"の場合の設定
	-- ローカル変数"colorscheme"に現在のカラースキームを代入"
	local colorscheme = vim.g.colors_name

	-- "colorscheme"が"industry"であれば真
	if colorscheme == "industry" then

		-- 特定の言語でハイライトしないようにする
		vim.treesitter.start = (function(wrapped)

			return function(bufnr, lang)

				local ft = vim.fn.getbufvar(bufnr or vim.fn.bufnr(''), '&filetype')

				local check = (

					ft == 'help' 
					or lang == 'bash'
					or lang == 'awk'
					or lang == 'html'

				)

				if check then

					return

				end

				wrapped(bufnr, lang)

			end

		end)(vim.treesitter.start)

	end

	-- masonの設定
	require('mason').setup{}

		local lspconfig = require('lspconfig')

		require('mason-lspconfig').setup_handlers{

			function(server_name)

				lspconfig[server_name].setup{

				capabilities = capabilities,

			}

			end,

		}

end

