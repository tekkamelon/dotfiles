-- lug_config.lua
-- neovim >= 0.10.0


-- プラグインのリスト
-- Jetpackの設定
vim.cmd('packadd vim-jetpack')
require('jetpack.packer').add {

	{'tani/vim-jetpack' , opt = true},

	-- vim script製プラグイン
	{'thinca/vim-partedit' , event = 'VisualEnter'},
	{'haya14busa/vim-edgemotion' , event = 'VimEnter'},
	{'skanehira/jumpcursor.vim' , event = 'VimEnter'},

	-- lua製プラグイン
	-- toggletermの設定
	{'akinsho/toggleterm.nvim',

		-- 起動に使用するコマンド
        cmd = {'ToggleTerm', 'ToggleTermSendCurrentLine', 'ToggleTermSendVisualLines'},

        config = function()

			-- vscode以外から起動した場合に真
			if not vim.g.vscode then

				require('toggleterm').setup{}

			end

        end,

	},

	'nvim-lua/plenary.nvim',
	'MunifTanjim/nui.nvim',

	-- telescopeの設定
	{'nvim-telescope/telescope.nvim' ,

 		branch = "dev",
 		lock = true,

		-- 依存関係のプラグイン
        dependencies = 'nvim-lua/plenary.nvim',

		-- 起動に使用するコマンド
		cmd = 'Telescope',

		config = function()

			if not vim.g.vscode then

				require('telescope').setup{

					defaults = {

						-- プロンプトの設定
						prompt_prefix = " 🔎 ",
						selection_caret = " ➤  "

					},

				}

			end

		end,

	},

	-- eyelinerの設定
	{'jinh0/eyeliner.nvim',

		event = 'UIEnter',

		config = function()

			require('eyeliner').setup{

				highlight_on_key = false,

			}

		end,

	 },

	-- neocodeiumの設定
	{'monkoose/neocodeium',

		cmd = 'NeoCodeium',

		event = 'InsertEnter',

		config = function()

			require('plugins.neocodeium')

		end,

	},

	-- CopilotChatの設定
	-- {'CopilotC-Nvim/CopilotChat.nvim',

	-- 	cmd = {'CopilotChat', 'CopilotChatToggle', 'CopilotChatReset', 'CopilotChatModels'},

	-- 	config = function()

	-- 		require('plugins.copilotchat')

	-- 	end,

	-- },
	{'yetone/avante.nvim',

		dependencies = {

			'nvim-treesitter/nvim-treesitter',
			'nvim-lua/plenary.nvim',
			'MunifTanjim/nui.nvim',
			'echasnovski/mini.icons',

		},

		run = "make BUILD_FROM_SOURCE=true",

        config = function()

			-- vscode以外から起動した場合に真
			if not vim.g.vscode then

				require('avante').setup{

					provider = "copilot",

					opts = {

						windows = {

						  position = 'bottom',
						  width = 100,
						  height = 40,

						},

					},

				}

			end

        end,


	},

		event = 'VimEnter',

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

	-- render-markdownの設定
	{'MeanderingProgrammer/render-markdown.nvim',

		dependencies = 'nvim-treesitter/nvim-treesitter',

		event = 'UIEnter',

		ft = 'markdown',

		config = function()

			require('plugins.render-markdown')

		end,

	},

	-- gitsignsの設定
	{'lewis6991/gitsigns.nvim',

		event = 'UIEnter',

		lock = true,

		config = function()

			-- vscode以外から起動した場合に真
			if not vim.g.vscode then

				require('gitsigns').setup{

					signs = {

						change = { text = '>>' },

					},

					numhl = true,

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

	-- mini.completionの設定
	{'echasnovski/mini.completion',

		event = 'InsertEnter',

		config = function()

			if not vim.g.vscode then

				require('mini.completion').setup{}

			end

		end,

	},

	-- mini.statuslineの設定
	{'echasnovski/mini.statusline',

		event = 'UIEnter',

		config = function()

			if not vim.g.vscode then

				require('mini.statusline').setup{

					use_icons = false,

				}

			end

		end

	},

	-- mini.tablineの設定
	{'echasnovski/mini.tabline',

		event = 'UIEnter',

		config = function()

			if not vim.g.vscode then

				require('mini.tabline').setup{

					show_icons = false,

				}

			end

		end

	},

	-- mini.commentの設定
	{'echasnovski/mini.comment',

		event = 'VimEnter',

		config = function()

			require('mini.comment').setup{

				-- 空白行を無視
				options = {ignore_blank_line = true,},

			}

		end,

	},

	-- mini.filesの設定
	{'echasnovski/mini.files',

		config = function()

			if not vim.g.vscode then

				require('mini.files')

			end

		end,

	},

	-- mini.surroundの設定
	{'echasnovski/mini.surround',

		event = 'VimEnter',

		config = function()

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

		end,

	},


	-- lsp関連
	'neovim/nvim-lspconfig',

	-- masonの設定
	{'williamboman/mason.nvim',

		config = function()

			if not vim.g.vscode then

				require('mason').setup{}

			end

		end,

	},

	-- mason-lspconfigの設定
 	{'williamboman/mason-lspconfig.nvim',

		-- バージョンを固定	
		-- これを記入しないと設定が壊れる
 		branch = "v1.x",
 		lock = true,

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

-- プラグインのキーマップ設定を読み込み
require('keymaps.plugins')

