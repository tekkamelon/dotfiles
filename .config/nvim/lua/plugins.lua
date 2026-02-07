-- plugins.lua
-- Neovim >= 0.11.0

-- lazy.nvimのブートストラップ処理
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy.nvimが存在しない場合はGitHubからクローン
local lazystat = vim.uv.fs_stat(lazypath)
if not lazystat or lazystat.type ~= "directory" then
	local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
		lazypath }
	vim.system(clone_cmd, { text = true }, function(obj)
		if obj.code ~= 0 then
			vim.notify("Failed to clone lazy.nvim: " .. (obj.stderr or ""), vim.log.levels.ERROR)
		end
	end)
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
	{ "copilotlsp-nvim/copilot-lsp",             lazy = true },
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
		event = "VeryLazy",
		config = function()
			require("plugins.noice")
		end,
	},

	-- telescopeの設定
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		cmd = {
			"Telescope",
			"TelescopeAvanteProvider"
		},
		config = function()
			require("plugins.telescope")
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

	-- copilot.luaの設定
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("plugins.copilot")
		end,
	},


	-- avanteの設定
	{
		"yetone/avante.nvim",
		build = "make",
		-- コマンドモードまたはビジュアルモードへの移行時に起動
		event = { "ModeChanged *:[cvV\x16]*" },
		cmd = {
			"AvanteAsk",
			"AvanteChat",
			"AvanteChatNew",
			"AvanteToggle",
			"AvanteModels",
			"AvanteSwitchProvider",
		},
		keys = {
			"<leader>a",
			"<leader>c",
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
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
		cmd = "MCPHub",
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
		event = { "BufReadPost", "BufNewFile" },
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
		event = { "BufReadPost", "BufNewFile" },
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
		event = "VeryLazy",
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
		event = "VeryLazy",
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
		keys = { "c", "l", "n" },
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
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins.mason-lsp")
		end,
	},
})

-- キーマップをUIEnterで遅延読み込み
vim.api.nvim_create_autocmd('UIEnter', {
	once = true,
	callback = function()
		require("keymaps.plugins")
	end
})
