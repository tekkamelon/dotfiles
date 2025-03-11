-- plug_config.lua
-- neovim >= 0.9.0


-- プラグインのリスト
-- Jetpackの設定
vim.cmd('packadd vim-jetpack')

require('jetpack.packer').add {

	{'tani/vim-jetpack' , opt = true},

	-- vim script製プラグイン
	{'thinca/vim-partedit' , event = 'VimEnter'},
	{'haya14busa/vim-edgemotion' , event = 'VimEnter'},
	{'skanehira/jumpcursor.vim' , event = 'VimEnter'},

	-- lua製プラグイン
	'ojroques/nvim-hardline',

	-- toggletermの設定
	{ 'akinsho/toggleterm.nvim',

		-- キーマッピングの設定
        keys = {

            '<leader>tt',
            '<leader>tv',
            '<leader>tf',
            '<leader>ts',

        },

		-- 起動に使用するコマンド
        cmd = {'ToggleTerm', 'ToggleTermSendCurrentLine', 'ToggleTermSendVisualLines'},

        config = function()

            require("toggleterm").setup{}

        end,

	},

	'nvim-lua/plenary.nvim',

	-- telescopeの設定
	{'nvim-telescope/telescope.nvim' ,

		lock = 1,

		-- キーマッピングの設定
        keys = {

            '<leader>ff',
            '<leader>fh',
            '<leader>fb',
            '<leader>fr',
            '<leader>fg'

        },

		-- 依存関係のプラグイン
        dependencies = { 'nvim-lua/plenary.nvim' },

		cmd = 'Telescope',

		config = function()

			require('telescope').setup{}

		end,

	},

	-- eyelinerの設定
	{'jinh0/eyeliner.nvim',

		event = 'VimEnter',

		config = function()

			require('eyeliner').setup {

				highlight_on_key = false,

			}

		end,

	 },

	'lewis6991/gitsigns.nvim',

	-- copilot.luaの設定
	{'zbirenbaum/copilot.lua',

		cmd = 'Copilot',

		event = 'InsertEnter',

		config = function()

			require('copilot').setup{

				-- サジェストの設定
				suggestion = {

					enabled = true,
					auto_trigger = true,
					hide_during_completion = true,
					debounce = 75,

					-- キーマッピングの設定
					keymap = {

						accept_word = false,
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

		end,
	},

	-- CopilotChatの設定
	{'CopilotC-Nvim/CopilotChat.nvim',

		event = 'VimEnter',

		config = function()

			require('CopilotChat').setup{

				-- デフォルトの言語モデルを変更
				model = "claude-3.5-sonnet",

				-- チャット用のバッファの設定
				window = {

					layout = 'horizontal',
					width = 0.5,
					height = 0.4,

				},

			}

		end,

	},

	-- treesitterの設定
    {'nvim-treesitter/nvim-treesitter',

		opt = true,

		event = 'VimEnter',

		config = function()

			require('nvim-treesitter.configs').setup{

				-- ハイライトを有効化
				highlight = {

					enable = true,

				},

			}

		end,

	},

	-- mini.nvimのモジュール
	-- mini.pairsの設定
	{'echasnovski/mini.pairs',

		event = 'InsertEnter',

		config = function()

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

		end,

	},

	'echasnovski/mini.completion',
	'echasnovski/mini.comment',
	'echasnovski/mini.surround',
	'echasnovski/mini.indentscope',

	-- mini.iconsの設定
    {'echasnovski/mini.icons',

        event = "VimEnter",

        config = function()

            require('mini.icons').setup{

                -- アイコンのスタイルを"ascii"に設定
                style = 'ascii',
            }

        end,

    },

	'echasnovski/mini.files',

	-- lspの設定
	'neovim/nvim-lspconfig',
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',

}

-- mini.commentの設定
require('mini.comment').setup{

	-- 空白行を無視
	options = {ignore_blank_line = true,},

}

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

-- ローカル変数を宣言
local vim_keymap = vim.keymap.set
local options = { noremap = true }

-- キーマップ設定を読み込み
require('keymaps.plugins')

-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then

	-- 真の場合は"vim-edgemotion"の設定の変更
	-- 1つ上のコードブロック
	vim_keymap({'n' , 'v'} , '<C-L>' , '<Plug>(edgemotion-k)' , options)

else

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

	-- mini.completionの設定
	require('mini.completion').setup{}

	-- mini.indentscopeの設定
	require('mini.indentscope').setup{}

	-- mini.filesの設定
	require('mini.files').setup{}

	local MiniFiles = require('mini.files')
	local minifiles_toggle = function()

		-- ファイラが開いていれば真
		if not MiniFiles.close()

			-- カレントバッファのディレクトリを表示
			then MiniFiles.open(vim.api.nvim_buf_get_name(0))

		end

	end

	-- gitsignsの設定
	require('gitsigns').setup{

		signs = {

			change = { text = '>>' },

		},

		numhl = true,

	}

	-- copilot.luaの設定
	-- インサートモード時の<Tab>キーの動作を定義
	vim_keymap("i", '<Tab>', function()

		-- ローカル変数を宣言
		local suggest = require("copilot.suggestion")

		-- copilotがサジェストしていれば真
		if suggest.is_visible() then

			-- サジェストを単語単位で受け入れ
			suggest.accept_word()

		else

			-- 通常の<Tab>キーの動作を実行
			vim.api.nvim_feedkeys(

				-- キーコードをneovimが理解可能な形式に変換
				vim.api.nvim_replace_termcodes("<Tab>" , true , false , true) , "n" , false

			)

		end

	end, {

		-- コマンドラインへの表示をオフ
		silent = true,

	})

	-- masonの設定
	require('mason').setup{}

		-- lspconfigの設定
		local lspconfig = require('lspconfig')

		require('mason-lspconfig').setup_handlers{

			function(server_name)

				lspconfig[server_name].setup{

				capabilities = capabilities,

			}

			end,

		}

	-- キーマップの設定
	local kmaps = {

		-- vim-partedit
		-- ビジュアルモード時にコマンドを表示
		{ 'v' , '<leader>e' , ':Partedit -opener new -filetype ' , options },

		-- telescope
		-- 隠しファイルを含めず検索
		{ 'n' , '<leader>ff' , ':Telescope find_files hidden=false previewer=false theme=get_dropdown<CR>' , options },
		-- 隠しファイルを含め検索
		{ 'n' , '<leader>fh' , ':Telescope find_files hidden=true previewer=false theme=get_dropdown<CR>' , options },
		-- バッファを検索
		{ 'n' , '<leader>fb' , ':Telescope buffers previewer=false theme=get_dropdown<CR>' , options },
		-- レジスタ一覧を検索
		{ 'n' , '<leader>fr' , ':Telescope registers<CR>' , options },
		-- ファイル内文字列を検索
		-- "$ sudo apt install ripgrep -y"で使用可能
		{ 'n' , '<leader>fg' , ':Telescope live_grep hidden=true previewer=true theme=get_dropdown<CR>' , options },

		-- toggleterm
		-- 下方,右側,フロートウィンドウのターミナルのトグル
		{ 'n' , '<leader>tt' , ':ToggleTerm size=20 direction=horizontal<CR>' , options },
		{ 'n' , '<leader>tv' , ':ToggleTerm size=60 direction=vertical<CR>' , options },
		{ 'n' , '<leader>tf' , ':ToggleTerm direction=float<CR>' , options },
		-- ノーマルモード時に現在カーソルのある行を,ビジュアルモード時に選択範囲をターミナルに送る
		{ 'n' , '<leader>ts' , ':ToggleTermSendCurrentLine<CR>' , options },
		{ 'v' , '<leader>ts' , ':ToggleTermSendVisualLines<CR>' , options },

		-- mini.files
		-- ファイラをトグル
		{ 'n', '<C-n>', minifiles_toggle, { noremap = true, silent = true } },

		-- copilot
		-- チャット用バッファをトグル
		{ {'n' , 'v'} , '<leader>cc' , ':CopilotChatToggle<CR>' , options },
		-- チャットをリセット
		{ {'n' , 'v'} , '<leader>cr' , ':CopilotChatReset<CR>' , options },
		-- 言語モデルを変更
		{ {'n' , 'v'} , '<leader>cm' , ':CopilotChatModels<CR>' , options },

	}

	-- テーブルの内容をループし代入
	for _, kmaps in pairs(kmaps) do

		vim_keymap(kmaps[1] , kmaps[2] , kmaps[3] , kmaps[4])

	end

end

