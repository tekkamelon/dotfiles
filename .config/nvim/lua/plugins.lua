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
	{
		"thinca/vim-partedit",
		-- ビジュアルモードへの移行時に起動
		event = "ModeChanged *:[vV\x16]*"
	},
	{
		"haya14busa/vim-edgemotion",
		event = { "BufReadPost", "BufNewFile" },
	},

	-- 依存関係用プラグイン
	{ "nvim-lua/plenary.nvim",                   lazy = true },
	{ "nvim-telescope/telescope-ui-select.nvim", lazy = true },
	{ "MunifTanjim/nui.nvim",                    lazy = true },
	{ "rcarriga/nvim-notify",                    lazy = true },
	{ "neovim/nvim-lspconfig",                   lazy = true },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		config = function()
			require("plugins.treesitter")
		end,
	},
	-- masonの設定
	{
		"williamboman/mason.nvim",
		lazy = true,
		config = function()
			if vim.g.vscode then return end
			require("mason").setup({})
		end,
	},

	-- lua製プラグイン
	-- toggletermの設定
	{
		"akinsho/toggleterm.nvim",
		cmd = {
			"ToggleTerm",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualLines"
		},
		config = function()
			-- vscode-neovimから起動した場合は実行しない
			if vim.g.vscode then return end
			require("toggleterm").setup({})
		end,
	},

	-- noiceの設定
	-- ":checkhealth noice"で必要なtreesitterパーサーを確認
	{
		"folke/noice.nvim",
		pin = true,
		event = "UIEnter",
		config = function()
			require("plugins.noice")
		end,
	},

	-- telescopeの設定
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		cmd = "Telescope",
		config = function()
			if vim.g.vscode then return end
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
		end,
	},

	-- eyelinerの設定
	{
		"jinh0/eyeliner.nvim",
		keys = { "h", "j", "k", "l", "f", "w", "b", "e", "ge" },
		opts = {
			highlight_on_key = false
		},
	},

	-- minuet-aiの設定
	{
		"milanglacier/minuet-ai.nvim",
		cmd = "Minuet",
		event = "InsertEnter",
		config = function()
			require("plugins.minuet")
		end,
	},

	-- avanteの設定
	{
		"yetone/avante.nvim",
		build = "make",
		event = { "ModeChanged *:[vV\x16]*" },
		cmd = { "AvanteToggle" },
		keys = "<leader>a",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.icons",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("plugins.avante")
		end,
	},

	-- mcphubの設定
	-- `sudo npm install -g mcp-hub`でインストール
	{
		"ravitemer/mcphub.nvim",
		lazy = true,
		opts = {
			extensions = {
				avante = {
					make_slash_commands = true,
				}
			},
		},
	},

	-- hlchunkの設定
	{
		"shellRaining/hlchunk.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.hlchunk")
		end,
	},

	-- render-markdownの設定
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = {
			"markdown",
			"vimwiki",
			"Avante"
		},
		config = function()
			require("plugins.render-markdown")
		end,
	},

	-- gitsignsの設定
	{
		"lewis6991/gitsigns.nvim",
		event = {
			"TextChanged",
			"TextChangedI",
			"TextChangedP",
			"BufWritePost",
		},
		pin = true,
		config = function()
			-- vscode以外から起動した場合に真
			if vim.g.vscode then return end
			require("gitsigns").setup({
				signs = {
					change = { text = ">>" },
				},
				numhl = true,
			})
		end,
	},

	-- hopの設定
	{
		"smoka7/hop.nvim",
		cmd = {
			"HopChar1",
			"HopChar2",
			"HopWord",
			"HopLine",
			"HopLineStart",
			"HopAnywhere",
			"HopAnywhereMW",
			"HopVertical",
			"HopPattern",
		},
		version = "*",
		opts = {
			keys = 'zxcvbqwertyuiopasdfghjkl'
		}
	},

	-- nvim-colorizerの設定
	{
		"norcalli/nvim-colorizer.lua",
		cmd = {
			"ColorizerAttachToBuffer",
			"ColorizerDetachFromBuffer",
			"ColorizerReloadAllBuffers",
			"ColorizerToggle",
		}
	},

	-- img-clipの設定
	-- `sudo apt install xclip`で使用可能
	{
		"HakonHarnes/img-clip.nvim",
		cmd = { "PasteImage", "ImgClip" },
		opts = {

			-- ファイルとして保存(base64ではない)
			embed_image_as_base64 = false,
			-- ファイル名を毎回聞かない
			prompt_for_filename = false,
			drag_and_drop = {
				insert_mode = true,
			},
			-- 相対パス
			use_absolute_path = false,
			-- 現在のファイルからの相対パス
			relative_to_current_file = true,
		},
	},

	-- mini.nvimのモジュール
	-- mini.pairsの設定
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		opts = {
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
	{
		"echasnovski/mini.icons",
		lazy = true,
		config = function()
			if vim.g.vscode then return end
			require("mini.icons").setup({
				-- アイコンのスタイルを"ascii"に設定
				style = "ascii",
			})
		end,
	},

	-- mini.completionの設定
	{
		"echasnovski/mini.completion",
		event = "InsertEnter",
		config = function()
			if vim.g.vscode then return end
			require("mini.completion").setup({})
		end,
	},

	-- mini.statuslineの設定
	{
		"echasnovski/mini.statusline",
		event = "UIEnter",
		config = function()
			if vim.g.vscode then return end
			require("mini.statusline").setup({
				use_icons = false,
			})
		end,
	},

	-- mini.tablineの設定
	{
		"echasnovski/mini.tabline",
		event = "UIEnter",
		config = function()
			if vim.g.vscode then return end
			require("mini.tabline").setup({
				show_icons = false,
			})
		end,
	},

	-- mini.commentの設定
	{
		"echasnovski/mini.comment",
		keys = "<leader>g",
		opts = {
			options = { ignore_blank_line = true },
		},
	},

	-- mini.filesの設定
	{
		"echasnovski/mini.files",
		keys = "<C-n>",
		dependencies = "echasnovski/mini.icons",
		config = function()
			require("plugins.mini-files")
		end,
	},

	-- mini.surroundの設定
	{
		"echasnovski/mini.surround",
		event = { "BufReadPost", "BufNewFile" },
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
	-- mason-lspconfigの設定
	{
		"williamboman/mason-lspconfig.nvim",
		pin = true,
		event = "FileType",
		config = function()
			require("plugins.mason-lsp")
		end,
	},
})

-- プラグインのキーマップ設定を読み込み
require("keymaps.plugins")
