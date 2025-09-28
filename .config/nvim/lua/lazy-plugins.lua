-- lazy-plugins.lua
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
	{ "thinca/vim-partedit", event = "VeryLazy" },
	{ "haya14busa/vim-edgemotion", event = "VeryLazy" },
	{ "skanehira/jumpcursor.vim", event = "VeryLazy" },

	-- 依存関係用プラグイン
	{"nvim-lua/plenary.nvim", lazy = true},
	{"nvim-telescope/telescope-ui-select.nvim", lazy = true},
	{"MunifTanjim/nui.nvim", lazy = true},
	{"rcarriga/nvim-notify", lazy = true},

	-- lua製プラグイン
	-- toggletermの設定
	{"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "ToggleTermSendCurrentLine", "ToggleTermSendVisualLines" },
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
		version = "0.1.6",
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
		-- event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("eyeliner").setup({
				highlight_on_key = false,
			})
		end,
	},

	-- neocodeiumの設定
	{"monkoose/neocodeium",
		-- version = "v1.14.1",
		cmd = "NeoCodeium",
		event = "InsertEnter",
		config = function()
			require("plugins.neocodeium")
		end,
	},

	-- minuetの設定
	-- {
	--   "milanglacier/minuet-ai.nvim",
	--   event = "InsertEnter",
	--   config = function()
	--	 require("plugins.minuet")
	--   end,
	-- },

	-- CopilotChatの設定
	{"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatToggle",
			"CopilotChatModels",
			"CopilotChatPrompts",
		},
		config = function()
			require("plugins.copilotchat")
		end,
	},

	-- mcphubの設定
	-- `sudo npm install -g mcp-hub`でインストール
	{"ravitemer/mcphub.nvim",
		event = "VimEnter",
		config = function()
			require("mcphub").setup({
				extensions = {
					copilotchat = {
						enabled = true,
						convert_tools_to_functions = true,
						convert_resources_to_functions = true,
						add_mcp_prefix = false,
					},
				},
			})
		end,
	},

	-- treesitterの設定
	{"nvim-treesitter/nvim-treesitter",
		-- event = "VeryLazy",
		lazy = true,
		config = function()
			require("plugins.treesitter")
		end,
	},

	-- hlchunkの設定
{"shellRaining/hlchunk.nvim",
	event = "VimEnter",
		config = function()
			require("plugins.hlchunk")
		end,
},

	-- render-markdownの設定
	{
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = "nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
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

	-- mini.nvimのモジュール
	-- mini.pairsの設定
	{"echasnovski/mini.pairs",
		event = "InsertEnter",
		config = function()
			require("mini.pairs").setup({
				mappings = {
					-- "<>"の設定
					["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
					[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
					-- "「」"の設定
					["「"] = { action = "open", pair = "「」", neigh_pattern = "[^\\]." },
					["」"] = { action = "close", pair = "「」", neigh_pattern = "[^\\]." },
				},
			})
		end,
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
		config = function()
			require("mini.comment").setup({
				-- 空白行を無視
				options = { ignore_blank_line = true },
			})
		end,
},

	-- mini.filesの設定
	{"echasnovski/mini.files",
		event = "VeryLazy",
		config = function()
			if not vim.g.vscode then
				require("mini.files")
			end
		end,
	},

	-- mini.surroundの設定
	{"echasnovski/mini.surround",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup({
				-- キーマッピングの設定
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
			})
		end,
	},

	-- lsp関連
	{"neovim/nvim-lspconfig", lazy = true},

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

