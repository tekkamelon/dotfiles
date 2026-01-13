-- init.lua
-- neovim >= 0.9.0

-- モジュールを遅延読み込み
vim.loader.enable()

-- 共通設定関数
local function set_global_options(options)
	for key, value in pairs(options) do
		vim.g[key] = value
	end
end

-- 統一設定関数
local function setup_options()
	-- 無効化する標準プラグイン
	local disabled_plugins = {
		did_install_default_menus = true,
		did_load_ftplugin = true,
		loaded_2html_plugin = true,
		loaded_getscript = true,
		loaded_getscriptPlugin = true,
		loaded_gzip = true,
		loaded_man = true,
		loaded_matchit = true,
		loaded_netrw = true,
		loaded_netrwFileHandlers = true,
		loaded_netrwPlugin = true,
		loaded_netrwSettings = true,
		loaded_remote_plugins = true,
		loaded_rrhelper = true,
		loaded_shada_plugin = true,
		loaded_spellfile_plugin = true,
		loaded_tarPlugin = true,
		loaded_tutor_mode_plugin = true,
		loaded_vimball = true,
		loaded_vimballPlugin = true,
		loaded_zipPlugin = true,
		skip_loading_mswin = true,
	}

	-- 全体設定
	local global_settings = {
		leader_key = ' ',
		hostname = vim.fn.hostname(),
	}

	-- vimオプション設定
	local vim_options = {
		-- 基本設定
		termguicolors = true,
		background = 'dark',
		number = true,
		cursorline = true,

		-- インデント設定
		tabstop = 4,
		shiftwidth = 4,

		-- ウィンドウ分割設定
		splitbelow = true,
		splitright = true,

		-- その他設定
		directory = '/tmp',
	}

	-- 一括設定適用
	set_global_options(disabled_plugins)
	set_global_options(global_settings)

	for key, value in pairs(vim_options) do
		vim.opt[key] = value
	end
end

-- 設定実行
setup_options()


-- 自動コマンドの設定
local create_autocmd = vim.api.nvim_create_autocmd

-- バッファイベントの定義
local buf_events = { 'BufNewFile', 'BufRead' }
local buf_new_event = 'BufNewFile'

-- 自動コマンドの設定テーブル
local autocmd_configs = {
	-- filetype設定
	{ buf_events,    { pattern = { '*conf*', '*rc' }, command = 'set filetype=conf' } },
	{ buf_events,    { pattern = '.*shrc', command = 'set filetype=sh' } },
	{ buf_events,    { pattern = '.vimrc', command = 'set filetype=vim' } },
	{ buf_events,    { pattern = '.tmux.conf', command = 'set filetype=tmux' } },

	-- テンプレート読み込み
	{ buf_new_event, { pattern = '*.sh', command = [[0r $HOME/Templates/sh.txt]] } },
	{ buf_new_event, { pattern = '*.awk', command = [[0r $HOME/Templates/awk.txt]] } },
	{ buf_new_event, { pattern = '*.py', command = [[0r $HOME/Templates/python.txt]] } },
	{ buf_new_event, { pattern = '*.c', command = [[0r $HOME/Templates/c.txt]] } },

	-- ターミナル設定
	{ 'TermOpen',    { pattern = '*', command = 'setlocal norelativenumber | setlocal nonumber' } }
}

-- 一括で自動コマンドを作成
for _, config in ipairs(autocmd_configs) do
	create_autocmd(config[1], config[2])
end


-- カラースキームの設定
-- ホスト名に基づくカラースキーム設定をテーブルで管理
local colorscheme_settings = {

	['default'] = { scheme = 'industry', termguicolors = true },
	['pop-os'] = { scheme = 'iceberg', termguicolors = true },
	['tekkamelon-pcg-2c7n'] = { scheme = 'default', termguicolors = false }

}

-- "hostname"に現在のマシンのホスト名を代入
local hostname = vim.fn.hostname()

-- "settings"にホスト名に応じたテーブルの値を代入
local settings = colorscheme_settings[hostname] or colorscheme_settings['default']

-- 設定を適用
vim.cmd.colorscheme(settings.scheme)
vim.opt.termguicolors = settings.termguicolors

-- ヤンクした範囲のハイライト
local function yank_highlight()
	-- ハイライトグループを"IncSearch",表示時間を200ミリ秒
	local config = { higroup = "IncSearch", timeout = 200 }

	-- テキストのヤンクで実行
	vim.api.nvim_create_autocmd('TextYankPost', {
		callback = function()
			vim.highlight.on_yank(config)
		end
	})
end

-- ハイライトの設定を遅延読み込み
vim.defer_fn(function()
	yank_highlight()
end, 0)

-- leaderの設定
vim.g.mapleader = " "

-- コマンドラインの高さを設定
vim.opt.cmdheight = 0
-- VSCode環境の場合、コマンドラインの高さを1に設定
if vim.g.vscode then
	vim.opt.cmdheight = 1
end

vim.opt.autoread = true

-- バッファの自動再読み込み
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	pattern = "*",
	callback = function() vim.cmd("silent! checktime") end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*",
	callback = function() print("File changed on disk. Reloaded.") end,
})

-- キーマップ設定を読み込み
require('keymaps.general')

-- プラグインの設定を読み込み
require('plugins')
