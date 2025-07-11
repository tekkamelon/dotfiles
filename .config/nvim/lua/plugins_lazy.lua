-- plugins.lua
-- neovim >= 0.10.0

-- lazy.nvimの自動インストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグインの設定
require("lazy").setup({

	-- vim script製プラグイン
	{
		'thinca/vim-partedit',
		event = 'VimEnter'
	},

	{
		'haya14busa/vim-edgemotion',
		event = 'VimEnter'
	},

	{
		'skanehira/jumpcursor.vim',
		event = 'VimEnter'
	},

	-- lua製プラグイン
	-- toggletermの設定
	{
		'akinsho/toggleterm.nvim',
		version = "*",
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
	{
		'nvim-telescope/telescope.nvim',
		branch = "0.1.x",
		dependencies = {'nvim-lua/plenary.nvim'},
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
	{
		'jinh0/eyeliner.nvim',
		event = 'VimEnter',
		config = function()
			require('eyeliner').setup{
				highlight_on_key = false,
			}
		end,
	},

	-- neocodeiumの設定
	{
		'monkoose/neocodeium',
		event = 'InsertEnter',
		config = function()
			require('plugins.neocodeium')
		end,
	},

	-- CopilotChatの設定
	-- {
	-- 	'CopilotC-Nvim/CopilotChat.nvim',
	-- 	cmd = {'CopilotChat', 'CopilotChatToggle', 'CopilotChatReset', 'CopilotChatModels'},
	-- 	config = function()
	-- 		require('plugins.copilotchat')
	-- 	end,
	-- },

	{
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false,
	opts = {
			provider = "copilot",
			auto_suggestions_provider = "copilot",
		
			-- 動作設定
			behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true,
			},

			-- ウィンドウ設定
			windows = {
			position = "bottom",
			wrap = true,
			width = 30,
			},
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"zbirenbaum/copilot.lua",
	}
	}

	-- treesitterの設定
	{
		'nvim-treesitter/nvim-treesitter',
		event = 'VimEnter',
		build = ':TSUpdate',
		config = function()
			require('plugins.treesitter')
		end,
	},

	-- hlchunkの設定
	{
		'shellRaining/hlchunk.nvim',
		event = 'VimEnter',
		config = function()
			require('plugins.hlchunk')
		end,
	},

	-- render-markdownの設定
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = {'nvim-treesitter/nvim-treesitter'},
		ft = 'markdown',
		config = function()
			require('plugins.render-markdown')
		end,
	},

	-- gitsignsの設定
	{
		'lewis6991/gitsigns.nvim',
		event = 'VimEnter',
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
	{
		'echasnovski/mini.pairs',
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
	{
		'echasnovski/mini.icons',
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
	{
		'echasnovski/mini.completion',
		event = 'InsertEnter',
		config = function()
			if not vim.g.vscode then
				require('mini.completion').setup{}
			end
		end,
	},

	-- mini.statuslineの設定
	{
		'echasnovski/mini.statusline',
		event = 'VimEnter',
		config = function()
			if not vim.g.vscode then
				require('mini.statusline').setup{
					use_icons = false,
				}
			end
		end
	},

	-- mini.tablineの設定
	{
		'echasnovski/mini.tabline',
		event = 'VimEnter',
		config = function()
			if not vim.g.vscode then
				require('mini.tabline').setup{
					show_icons = false,
				}
			end
		end
	},

	-- mini.commentの設定
	{
		'echasnovski/mini.comment',
		event = 'VimEnter',
		config = function()
			require('mini.comment').setup{
				-- 空白行を無視
				options = {ignore_blank_line = true,},
			}
		end,
	},

	-- mini.filesの設定
	{
		'echasnovski/mini.files',
		event = 'VimEnter',
		config = function()
			if not vim.g.vscode then
				require('mini.files').setup{}
			end
		end,
	},

	-- mini.surroundの設定
	{
		'echasnovski/mini.surround',
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
	{
		'williamboman/mason.nvim',
		config = function()
			if not vim.g.vscode then
				require('mason').setup{}
			end
		end,
	},

	-- mason-lspconfigの設定
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = {
			'neovim/nvim-lspconfig',
			'williamboman/mason.nvim'
		},
		config = function()
			require('plugins.mason-lsp')
		end,
	},

})

-- プラグインのキーマップ設定を読み込み
require('keymaps.plugins')
