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

		-- 起動に使用するコマンド
        cmd = {'ToggleTerm', 'ToggleTermSendCurrentLine', 'ToggleTermSendVisualLines'},

        config = function()

			-- vscode-neovimから起動していない場合に真
			if not vim.g.vscode then

				require('toggleterm').setup{}

			end

        end,

	},

	'nvim-lua/plenary.nvim',

	-- telescopeの設定
	{'nvim-telescope/telescope.nvim' ,

		lock = 1,

		-- 依存関係のプラグイン
        dependencies = 'nvim-lua/plenary.nvim',

		-- 起動に使用するコマンド
		cmd = 'Telescope',

		config = function()

			if not vim.g.vscode then

				require('telescope').setup{}

			end

		end,

	},

	-- eyelinerの設定
	{'jinh0/eyeliner.nvim',

		event = 'VimEnter',

		config = function()

			require('eyeliner').setup{

				highlight_on_key = false,

			}

		end,

	 },

	-- copilot.luaの設定
	{'zbirenbaum/copilot.lua',

		cmd = 'Copilot',

		event = 'InsertEnter',

		config = function()

			if not vim.g.vscode then

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

			end

		end,
	},

	-- CopilotChatの設定
	{'CopilotC-Nvim/CopilotChat.nvim',

		event = 'VimEnter',

		config = function()

			if not vim.g.vscode then

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

			end

		end,

	},

	-- treesitterの設定
    {'nvim-treesitter/nvim-treesitter',

		event = 'VimEnter',

		config = function()

			if not vim.g.vscode then

				require('nvim-treesitter.configs').setup{

					-- ハイライトを有効化
					highlight = {

						enable = true,

					},

				}

			end

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

	-- mini.iconsの設定
    {'echasnovski/mini.icons',

        event = "VimEnter",

        config = function()

			if not vim.g.vscode then

				require('mini.icons').setup{

					-- アイコンのスタイルを"ascii"に設定
					style = 'ascii',

				}

			end

        end,

    },

	'echasnovski/mini.completion',
	'echasnovski/mini.comment',
	'echasnovski/mini.surround',
	'echasnovski/mini.files',

	-- lsp関連
	'neovim/nvim-lspconfig',
	'williamboman/mason-lspconfig.nvim',
	'williamboman/mason.nvim',

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

-- vscode以外から起動した場合に真
if not vim.g.vscode then

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

	-- mini.filesの設定
	require('mini.files').setup{}

	-- gitsignsの設定
	require('gitsigns').setup{

		signs = {

			change = { text = '>>' },

		},

		numhl = true,

	}

end

	-- lspの設定
	require('mason').setup{}

	-- lspconfigの設定
	local lspconfig = require('lspconfig')
	local  capabilities = vim.lsp.protocol.make_client_capabilities()

	require('mason-lspconfig').setup_handlers{

		function(server_name)

			lspconfig[server_name].setup{

				capabilities = capabilities,

			}

		end,

	}

end

-- プラグインのキーマップ設定を読み込み
require('keymaps.plugins')

