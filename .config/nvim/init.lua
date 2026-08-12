-- init.lua
-- neovim >= 0.9.0

-- モジュールを遅延読み込み
vim.loader.enable()

local g = vim.g
local opt = vim.opt
local o = vim.o
local bo = vim.bo
local wo = vim.wo
local api = vim.api
local cmd = vim.cmd
local on_yank = vim.highlight.on_yank

-- 設定の統合と一括適用
local function setup_options()
	-- 無効化する標準プラグイン
	local disabled_builtins = {
		'2html_plugin',
		'getscript',
		'getscriptPlugin',
		'gzip',
		'man',
		'matchit',
		-- netrwの設定
		-- 'netrw',
		-- 'netrwFileHandlers',
		-- 'netrwPlugin',
		'netrwSettings',
		'remote_plugins',
		'rrhelper',
		'shada_plugin',
		'spellfile_plugin',
		'tarPlugin',
		'tutor_mode_plugin',
		'vimball',
		'vimballPlugin',
		'zipPlugin',
	}

	-- 無効化プラグインを一括設定
	for _, plugin in ipairs(disabled_builtins) do
		g['loaded_' .. plugin] = 1
	end

	-- グローバル変数
	local g_config = {
		did_install_default_menus = 0,
		did_load_ftplugin = 0,
		skip_loading_mswin = 1,
		mapleader = ' ',
	}

	-- vimオプション
	local opt_config = {
		-- 基本設定
		termguicolors = true,
		background = 'dark',
		number = true,
		cursorline = true,
		cmdheight = 0,
		autoread = true,

		-- インデント設定
		tabstop = 4,
		shiftwidth = 4,

		-- ウィンドウ分割設定
		splitbelow = true,
		splitright = true,

		-- その他設定
		directory = '/tmp',
	}

	-- 設定を一括適用
	for key, value in pairs(g_config) do
		g[key] = value
	end
	for key, value in pairs(opt_config) do
		opt[key] = value
	end

	-- VSCode環境の場合のみcmdheightを上書き
	if g.vscode then
		opt.cmdheight = 1
	end
end

-- 設定実行
setup_options()

-- 自動コマンドの統合設定
local autocmd_group = api.nvim_create_augroup('UserConfig', { clear = true })

local autocmds = {
	-- filetype設定
	{ { 'BufNewFile', 'BufRead' }, { pattern = { '*conf*', '*rc' }, callback = function() bo.filetype = 'conf' end } },
	{ { 'BufNewFile', 'BufRead' }, { pattern = '.*shrc', callback = function() bo.filetype = 'sh' end } },
	{ { 'BufNewFile', 'BufRead' }, { pattern = '.vimrc', callback = function() bo.filetype = 'vim' end } },
	{ { 'BufNewFile', 'BufRead' }, { pattern = '.tmux.conf', callback = function() bo.filetype = 'tmux' end } },
	{ { 'BufNewFile', 'BufRead' }, { pattern = '.env*', callback = function() bo.filetype = 'env' end } },

	-- テンプレート読み込み
	{ 'BufNewFile',                { pattern = '*.awk', callback = function() cmd('0r $HOME/Templates/awk.txt') end } },
	{ 'BufNewFile',                { pattern = '*.py', callback = function() cmd('0r $HOME/Templates/python.txt') end } },
	{ 'BufNewFile',                { pattern = '*.c', callback = function() cmd('0r $HOME/Templates/c.txt') end } },
	{ 'BufNewFile',                { pattern = '*.sh', callback = function() cmd('0r $HOME/Templates/sh.txt') end } },

	-- ターミナル設定
	{ 'TermOpen', {
		pattern = '*',
		callback = function()
			wo.relativenumber = false
			wo.number = false
		end,
	} },

	-- バッファの自動再読み込み (確認プロンプトとhit-enterを出さない)
	{ { 'FocusGained', 'BufEnter', 'CursorHold' }, {
		pattern = '*',
		callback = function()
			if vim.fn.mode() ~= 'c' then
				cmd('silent! checktime')
			end
		end,
	} },
	{ 'FileChangedShell', {
		pattern = '*',
		callback = function()
			vim.v.fcs_choice = 'reload'
		end,
	} },

	-- ヤンク時のハイライトの設定
	{ 'TextYankPost', {
		pattern = '*',
		callback = function()
			on_yank({ higroup = 'IncSearch', timeout = 200 })
		end,
	} },

	-- キーマップをUIEnterで遅延読み込み
	{ 'UIEnter', {
		pattern = '*',
		once = true,
		callback = function()
			require('keymaps.general')
		end,
	} },

	-- マクロ記録開始時にcmdheightを1に設定
	{ 'RecordingEnter', {
		pattern = '*',
		callback = function()
			o.cmdheight = 1
		end,
	} },

	-- マクロ記録終了時にcmdheightを0に戻す
	{ 'RecordingLeave', {
		pattern = '*',
		callback = function()
			o.cmdheight = 0
		end,
	} },
}

-- 一括で自動コマンドを作成
for _, autocmd in ipairs(autocmds) do
	autocmd.group = autocmd_group
	api.nvim_create_autocmd(autocmd[1], autocmd[2])
end

-- カラースキームを設定
local function setup_colorscheme()
	local hostname = vim.fn.hostname()
	local colorscheme_map = {
		['pop-os'] = { scheme = 'iceberg', termguicolors = true },
		['tekkamelon-pcg-2c7n'] = { scheme = 'default', termguicolors = false },
	}

	local config = colorscheme_map[hostname] or { scheme = 'industry', termguicolors = true }
	cmd.colorscheme(config.scheme)
	opt.termguicolors = config.termguicolors
end

setup_colorscheme()

-- プラグインの読み込み
require('plugins')