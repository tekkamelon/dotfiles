-- plugins.lua
-- Neovim >= 0.11.0


-- lazy.nvimのブートストラップ処理
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- vim script製プラグイン
	{"thinca/vim-partedit", event = "VeryLazy"},
	{"haya14busa/vim-edgemotion", event = "VeryLazy"},

	-- 依存関係用プラグイン
	{"nvim-lua/plenary.nvim", lazy = true},
	{"nvim-telescope/telescope-ui-select.nvim", lazy = true},
	{"MunifTanjim/nui.nvim", lazy = true},
	{"rcarriga/nvim-notify", lazy = true},
	{"neovim/nvim-lspconfig", lazy = true},
	{"nvim-treesitter/nvim-treesitter",
		lazy = true,
		config = function()
			require("plugins.treesitter")
		end,
	},

	-- lua製プラグイン
	-- toggletermの設定
	{"akinsho/toggleterm.nvim",
		cmd = {
			"ToggleTerm",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualLines"
		},
		config = function()
			-- vscode以外から起動した場合に真
			if not vim.g.vscode then
				require("toggleterm").setup({})
			end
		end,
	},

	-- noiceの設定
	-- ":checkhealth noice"で必要なtreesitterパーサーを確認
	{"folke/noice.nvim",
		pin = true,
		event = "UIEnter",
		config = function()
			require("plugins.noice")
		end,
	},

	-- telescopeの設定
	{"nvim-telescope/telescope.nvim",
		lazy = true,
		cmd = "Telescope",
		config = function()
			if not vim.g.vscode then
				require("telescope").setup({
					defaults = {
						-- プロンプトの設定
						prompt_prefix = " 🔎 ",
						selection_caret = " ➤	 ",
					},
					-- telescope-ui-selectの設定
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
				})
				require("telescope").load_extension("ui-select")
			end
		end,
	},

	-- eyelinerの設定
	{"jinh0/eyeliner.nvim",
		event = "VeryLazy",
		opts = {
			highlight_on_key = false
		}
	},

	-- neocodeiumの設定
	{"monkoose/neocodeium",
		cmd = "NeoCodeium",
		event = "InsertEnter",
		config = function()
			require("plugins.neocodeium")
		end,
	},

	-- avanteの設定
	{"yetone/avante.nvim",
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.icons",
			"nvim-telescope/telescope.nvim",
		},

		cmd = {
			"AvanteAsk",
			"AvanteBuild",
			"AvanteChat",
			"AvanteChatNew",
			"AvanteHistory",
			"AvanteRefresh",
			"AvanteStop",
			"AvanteSwitchProvider",
			"AvanteToggle",
			"AvanteModels",
			"AvanteSwitchProvider",
		},
		config = function()
			require("plugins.avante")
		end,
	},

	-- nvim-windowの設定
	{"yorickpeterse/nvim-window",
		event = "BufAdd",
		keys = {
			{
				"<leader>u",
				"<cmd>lua require('nvim-window').pick()<cr>",
				desc = "nvim-window: Jump to window"
			},
		},
		config = true,
	},

	-- mcphubの設定
	-- `sudo npm install -g mcp-hub`でインストール
	{"ravitemer/mcphub.nvim",
		event = "VeryLazy",
		opts = {
			extensions = {
				avante = {
					make_slash_commands = true,
				}
			},
		},
	},

	-- hlchunkの設定
	{"shellRaining/hlchunk.nvim",
		event = "VimEnter",
			config = function()
				require("plugins.hlchunk")
			end,
	},

	-- render-markdownの設定
	{"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		config = function()
			require("plugins.render-markdown")
		end,
	},

	-- gitsignsの設定
	{"lewis6991/gitsigns.nvim",
		event = "UIEnter",
			pin = true,
			config = function()
				-- vscode以外から起動した場合に真
				if not vim.g.vscode then
					require("gitsigns").setup({
						signs = {
							change = { text = ">>" },
						},
						numhl = true,
					})
				end
		end,
	},

	-- hopの設定
	{"smoka7/hop.nvim",
		cmd = {

			"HopWord",
			"HopAnywhere",
			"HopChar1",
			"HopChar2",
			"HopLine",
			"HopWordMW",
			"HopChar1MW",
			"HopChar2MW",
			"HopLineMW",

		},
		version = "*",
		opts = {
			keys = 'etovxqpdygfblzhckisuran'
		}
	},

	-- mini.nvimのモジュール
	-- mini.pairsの設定
	{"echasnovski/mini.pairs",
		event = "InsertEnter",
		opts= {
			mappings = {
				-- "<>"の設定
				["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
				[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
				-- "「」"の設定
				["「"] = { action = "open", pair = "「」", neigh_pattern = "[^\\]." },
				["」"] = { action = "close", pair = "「」", neigh_pattern = "[^\\]." },
			},

		}
	},

	-- mini.iconsの設定
	{"echasnovski/mini.icons",
		-- event = "VimEnter",
		lazy = true,
		config = function()
			if not vim.g.vscode then
				require("mini.icons").setup({
					-- アイコンのスタイルを"ascii"に設定
					style = "ascii",
				})
			end
		end,
	},

	-- mini.completionの設定
	{"echasnovski/mini.completion",
		event = "InsertEnter",
		config = function()
			if not vim.g.vscode then
				require("mini.completion").setup({})
			end
		end,
	},

	-- mini.statuslineの設定
	{"echasnovski/mini.statusline",
		event = "UIEnter",
		config = function()
			if not vim.g.vscode then
				require("mini.statusline").setup({
					use_icons = false,
				})
			end
		end,
	},

	-- mini.tablineの設定
	{"echasnovski/mini.tabline",
		event = "UIEnter",
		config = function()
			if not vim.g.vscode then
				require("mini.tabline").setup({
					show_icons = false,
				})
			end
		end,
	},

	-- mini.commentの設定
	{"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			options = { ignore_blank_line = true },
		},
	},

	-- mini.filesの設定
	{"echasnovski/mini.files",
		event = "VeryLazy",
		dependencies = "echasnovski/mini.icons",
		config = function()
			require("plugins.mini-files")
		end,
	},

	-- mini.surroundの設定
	{"echasnovski/mini.surround",
		event = "VeryLazy",
		opts = {
			-- キーマップの設定
			mappings = {
				add = "ca",
				delete = "cd",
				find = "cf",
				find_left = "cF",
				highlight = "ch",
				replace = "cr",
				update_n_lines = "cn",
				suffix_last = "l",
				suffix_next = "n",
			},
			-- 矩形選択時に各行を囲む
			respect_selection_type = true,
		},
	},

	-- lsp関連
	-- masonの設定
	{"williamboman/mason.nvim",
		lazy = true,
		config = function()
				if not vim.g.vscode then
					require("mason").setup({})
				end
			end,
	},

	-- mason-lspconfigの設定
	{"williamboman/mason-lspconfig.nvim",
		pin = true,
		event = "VeryLazy",
		config = function()
			require("plugins.mason-lsp")
		end,
	},
})

-- プラグインのキーマップ設定を読み込み
require("keymaps.plugins")

