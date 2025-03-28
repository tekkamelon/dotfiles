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
	{'akinsho/toggleterm.nvim',

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

			require('plugins.copilot')

		end,
	},

	-- CopilotChatの設定
	{'CopilotC-Nvim/CopilotChat.nvim',

		cmd = {'CopilotChatToggle', 'CopilotChatReset', 'CopilotChatModels'},

		config = function()

			require('plugins.copilotchat')

		end,

	},

	-- treesitterの設定
    {'nvim-treesitter/nvim-treesitter',

		event = 'VimEnter',

		config = function()

			require('plugins.treesitter')

		end,

	},

	-- hlchunkの設定
	{'shellRaining/hlchunk.nvim',

	 	event = 'VimEnter',

		config = function()

			require('plugins.hlchunk')

		end,

	},

	'lewis6991/gitsigns.nvim',

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

	-- mini.completionの設定
	{'echasnovski/mini.completion',

		event = 'InsertEnter',

		config = function()

			if not vim.g.vscode then

				require('mini.completion').setup{}

			end

		end,

	},

	'echasnovski/mini.comment',
	'echasnovski/mini.surround',
	'echasnovski/mini.files',

	-- lsp関連
	{'neovim/nvim-lspconfig',

		event = 'VeryLazy',

	},

	{'williamboman/mason.nvim',

		event = 'VeryLazy',

		config = function()

			require('mason').setup{}

		end,

	},

	{'williamboman/mason-lspconfig.nvim',

		event = 'VeryLazy',

		-- 依存関係のプラグイン
		dependencies = {

			'neovim/nvim-lspconfig',
			'williamboman/mason.nvim'

		},

		config = function()

			require('plugins.mason-lsp')

		end,

	},


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

-- プラグインのキーマップ設定を読み込み
require('keymaps.plugins')

