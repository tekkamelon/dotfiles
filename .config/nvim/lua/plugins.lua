-- plugins.lua
-- Neovim >= 0.12.0
-- プラグイン管理: vim.pack
-- 遅延読み込み: lz.n

-- lz.nは遅延読み込みの管理側なので最初に追加する
-- init.luaの読み込み中はload=false相当となり, packadd!でruntimepathだけが追加される
vim.pack.add({
	{ src = "https://github.com/lumen-oss/lz.n" },
}, { confirm = false })

-- 起動時にsetupを必要としない依存関係用プラグインはvim.packで管理
-- runtimepathに追加するだけで, plugin/以下のスクリプトは読み込まない
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/Kaiser-Yang/blink-cmp-avante" },
}, { confirm = false })

-- avante.nvimのビルドをインストール/更新後に実行する
-- build.shは旧リポジトリ名 (yetone/avante.nvim) を参照しており,
-- GitHub APIのリダイレクトを追跡できないため, 実行前に現行のリポジトリ名へ置換する
local function build_avante(path)
	local script = path .. "/build.sh"
	local patched, lines = pcall(vim.fn.readfile, script)
	if patched then
		for i, line in ipairs(lines) do
			lines[i] = line:gsub('REPO_OWNER="yetone"', 'REPO_OWNER="avante-corp"')
		end
		vim.fn.writefile(lines, script)
	end

	local result = vim.system({ "make" }, { cwd = path }):wait()

	-- 一時的に変更したbuild.shを元に戻す
	if patched then
		vim.system({ "git", "-C", path, "checkout", "--", "build.sh" }):wait()
	end

	return result
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name ~= "avante.nvim" then return end
		if ev.data.kind ~= "install" and ev.data.kind ~= "update" then return end

		local result = build_avante(ev.data.path)
		if result.code ~= 0 then
			vim.notify(
				"avante.nvimのビルドに失敗しました: " .. (result.stderr or ""),
				vim.log.levels.ERROR
			)
		end
	end,
})

-- プラグインのインストールのみをvim.packで行い, 読み込みはlz.nに任せる
-- loadを空関数にすることでvim.pack.add時のpackaddを抑止する
vim.pack.add({
	-- vim script製プラグイン
	{ src = "https://github.com/thinca/vim-partedit" },
	{ src = "https://github.com/haya14busa/vim-edgemotion" },

	-- lua製プラグイン
	-- nvim-treesitter(main branch)はparserのbuildにtree-sitter CLI (0.26.1 or later)とC compilerを要求する
	-- 前提条件: cc/gcc等のC compilerがPATHにあること
	-- tree-sitter CLIの導入手順 (npm経由は非推奨, apt版は0.22.6と古いためGitHubのbinaryを使用):
	--   curl -sL https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.13/tree-sitter-linux-x64.gz | gzip -dc > ~/.local/bin/tree-sitter && chmod +x ~/.local/bin/tree-sitter
	-- version確認: tree-sitter --version
	-- Neovim 0.12ではfrozenのmasterではなくmainブランチを使用
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },

	-- masonの設定
	{ src = "https://github.com/williamboman/mason.nvim" },

	-- toggletermの設定
	{ src = "https://github.com/akinsho/toggleterm.nvim" },

	-- ":checkhealth noice"で必要なtreesitterパーサーを確認
	-- 以前の環境で導入済みのリビジョンを固定
	{
		src = "https://github.com/folke/noice.nvim",
		version = "0427460c2d7f673ad60eb02b35f5e9926cf67c59",
	},

	-- telescopeの設定
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- eyelinerの設定
	{ src = "https://github.com/jinh0/eyeliner.nvim" },

	-- img-clipの設定
	{ src = "https://github.com/HakonHarnes/img-clip.nvim" },

	-- avanteの設定
	-- 以前の環境で導入済みのリビジョン (v0.0.29) を固定
	{
		src = "https://github.com/avante-corp/avante.nvim",
		version = "61f38b6d83c632d8778407993664809889c5511b",
	},

	-- hlchunkの設定
	{ src = "https://github.com/shellRaining/hlchunk.nvim" },

	-- render-markdownの設定
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },

	-- gitsignsの設定
	-- 以前の環境で導入済みのリビジョンを固定
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		version = "0cb5a7753d3c4b8e9cfdc9d88d9110cb8d4b1544",
	},

	-- hopの設定
	{ src = "https://github.com/smoka7/hop.nvim", version = vim.version.range("*") },

	-- nvim-colorizerの設定
	{ src = "https://github.com/norcalli/nvim-colorizer.lua" },

	-- mini.nvimのモジュール
	{ src = "https://github.com/echasnovski/mini.pairs" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/echasnovski/mini.statusline" },
	{ src = "https://github.com/echasnovski/mini.tabline" },
	{ src = "https://github.com/echasnovski/mini.surround" },

	-- blink.cmpの設定
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },

	-- lsp関連
	-- mason-lspconfigの設定
	-- 以前の環境で導入済みのリビジョンを固定
	{
		src = "https://github.com/williamboman/mason-lspconfig.nvim",
		version = "155eac5d8609a2f110041f8ac3491664cc126354",
	},
}, { confirm = false, load = function() end })

-- 依存プラグインを先に読み込む
local function load_deps(...)
	local deps = { ... }
	return function()
		if vim.g.vscode then return end
		require("lz.n").trigger_load(deps)
	end
end

-- 遅延読み込みの設定
-- before: 依存プラグインの読み込み, after: 従来のconfig/optsに相当
require("lz.n").load({
	-- vim script製プラグイン
	{
		"vim-partedit",
		-- ビジュアルモードへの移行時に起動
		event = "ModeChanged *:[vV\x16]*",
	},
	{
		"vim-edgemotion",
		event = { "BufReadPost", "BufNewFile" },
	},

	-- nvim-lspconfigの読み込み時にcopilotの設定も読み込む
	{
		"nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile", "InsertEnter" },
		after = function()
			require("plugins.copilot")
		end,
	},

	-- lua製プラグイン
	{
		"nvim-treesitter",
		event = "DeferredUIEnter",
		after = function()
			require("plugins.treesitter")
		end,
	},

	-- masonの設定
	{
		"mason.nvim",
		cmd = "Mason",
		after = function()
			if vim.g.vscode then return end
			require("mason").setup({})
		end,
	},

	-- toggletermの設定
	{
		"toggleterm.nvim",
		cmd = {
			"ToggleTerm",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualLines",
		},
		after = function()
			-- vscode-neovimから起動した場合は実行しない
			if vim.g.vscode then return end
			require("toggleterm").setup({})
		end,
	},

	-- ":checkhealth noice"で必要なtreesitterパーサーを確認
	{
		"noice.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("plugins.noice")
		end,
	},

	-- telescopeの設定
	{
		"telescope.nvim",
		cmd = {
			"Telescope",
			"TelescopeAvanteProvider",
		},
		after = function()
			require("plugins.telescope")
		end,
	},

	-- eyelinerの設定
	{
		"eyeliner.nvim",
		keys = { "h", "j", "k", "l", "f", "w", "b", "e", "ge" },
		after = function()
			require("eyeliner").setup({
				highlight_on_key = false,
			})
		end,
	},

	-- img-clipの設定
	{
		"img-clip.nvim",
		cmd = "PasteImage",
		after = function()
			require("plugins.img-clip")
		end,
	},

	-- avanteの設定
	{
		"avante.nvim",
		-- コマンドモードまたはビジュアルモードへの移行時に起動
		event = { "ModeChanged *:[cvV\x16]*" },
		cmd = {
			"AvanteAsk",
			"AvanteChat",
			"AvanteChatNew",
			"AvanteToggle",
			"AvanteModels",
			"AvanteSwitchProvider",
			"AvanteClear",
		},
		before = load_deps("nvim-treesitter", "mini.icons", "telescope.nvim"),
		after = function()
			require("plugins.avante")
		end,
	},

	-- hlchunkの設定
	{
		"hlchunk.nvim",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("plugins.hlchunk")
		end,
	},

	-- render-markdownの設定
	{
		"render-markdown.nvim",
		ft = {
			"markdown",
			"vimwiki",
			"Avante",
		},
		after = function()
			require("plugins.render-markdown")
		end,
	},

	-- gitsignsの設定
	{
		"gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
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
		"hop.nvim",
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
		after = function()
			require("hop").setup({
				keys = "zxcvbqwertyuiopasdfghjkl",
			})
		end,
	},

	-- nvim-colorizerの設定
	{
		"nvim-colorizer.lua",
		cmd = {
			"ColorizerAttachToBuffer",
			"ColorizerDetachFromBuffer",
			"ColorizerReloadAllBuffers",
			"ColorizerToggle",
		},
	},

	-- mini.nvimのモジュール
	-- mini.pairsの設定
	{
		"mini.pairs",
		event = "InsertEnter",
		after = function()
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
	-- blink.cmpとavante.nvimのbeforeフックから読み込む
	{
		"mini.icons",
		lazy = true,
		after = function()
			if vim.g.vscode then return end
			require("mini.icons").setup({
				-- アイコンのスタイルを"ascii"に設定
				style = "ascii",
			})
		end,
	},

	-- blink.cmpの設定
	{
		"blink.cmp",
		event = "InsertEnter",
		before = load_deps("mini.icons"),
		after = function()
			if vim.g.vscode then return end
			require("plugins.blink-cmp")
		end,
	},

	-- mini.statuslineの設定
	{
		"mini.statusline",
		event = "DeferredUIEnter",
		after = function()
			if vim.g.vscode then return end
			require("mini.statusline").setup({
				use_icons = false,
			})
		end,
	},

	-- mini.tablineの設定
	{
		"mini.tabline",
		event = "DeferredUIEnter",
		after = function()
			if vim.g.vscode then return end
			require("mini.tabline").setup({
				show_icons = false,
			})
		end,
	},

	-- mini.surroundの設定
	{
		"mini.surround",
		event = "ModeChanged *:[vV\x16]*",
		after = function()
			require("mini.surround").setup({
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
			})
		end,
	},

	-- lsp関連
	-- mason-lspconfigの設定
	{
		"mason-lspconfig.nvim",
		event = { "BufReadPost", "BufNewFile" },
		before = load_deps("mason.nvim", "nvim-lspconfig"),
		after = function()
			require("plugins.mason-lsp")
		end,
	},
})

-- ui2をUIEnterで有効化
-- vim.api.nvim_create_autocmd('UIEnter', {
-- 	once = true,
-- 	callback = function()
-- 		require("plugins.ui2")
-- 	end
-- })

-- キーマップをUIEnterで遅延読み込み
vim.api.nvim_create_autocmd('UIEnter', {
	once = true,
	callback = function()
		require("keymaps.plugins")
	end
})
