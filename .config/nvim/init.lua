-- init.lua
-- neovim >= 0.9.0

-- モジュールを遅延読み込み
vim.loader.enable()

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
		'netrw',
		'netrwFileHandlers',
		'netrwPlugin',
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
		vim.g['loaded_' .. plugin] = 1
	end

	-- グローバル変数とvimオプションを統合して一括設定
	local config = {
		-- グローバル変数
		g = {
			did_install_default_menus = 0,
			did_load_ftplugin = 0,
			skip_loading_mswin = 1,
			mapleader = ' ',
		},
		-- vimオプション
		opt = {
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
	}

	-- 設定を一括適用
	for scope, settings in pairs(config) do
		for key, value in pairs(settings) do
			vim[scope][key] = value
		end
	end

	-- VSCode環境の場合のみcmdheightを上書き
	if vim.g.vscode then
		vim.opt.cmdheight = 1
	end
end

-- 設定実行
setup_options()


-- 自動コマンドの統合設定
local autocmd_group = vim.api.nvim_create_augroup('UserConfig', { clear = true })

local autocmds = {
	-- filetype設定
	{ { 'BufNewFile', 'BufRead' }, { pattern = { '*conf*', '*rc' }, callback = function() vim.bo.filetype = 'conf' end } },
	{ { 'BufNewFile', 'BufRead' }, { pattern = '.*shrc', callback = function() vim.bo.filetype = 'sh' end } },
	{ { 'BufNewFile', 'BufRead' }, { pattern = '.vimrc', callback = function() vim.bo.filetype = 'vim' end } },
	{ { 'BufNewFile', 'BufRead' }, { pattern = '.tmux.conf', callback = function() vim.bo.filetype = 'tmux' end } },

	-- テンプレート読み込み
	{ 'BufNewFile',                { pattern = '*.sh', callback = function() vim.cmd('0r $HOME/Templates/sh.txt') end } },
	{ 'BufNewFile',                { pattern = '*.awk', callback = function() vim.cmd('0r $HOME/Templates/awk.txt') end } },
	{ 'BufNewFile',                { pattern = '*.py', callback = function() vim.cmd('0r $HOME/Templates/python.txt') end } },
	{ 'BufNewFile',                { pattern = '*.c', callback = function() vim.cmd('0r $HOME/Templates/c.txt') end } },

	-- ターミナル設定
	{ 'TermOpen', {
		pattern = '*',
		callback = function()
			vim.wo.relativenumber = false
			vim.wo.number = false
		end
	} },

	-- バッファの自動再読み込み
	{ { 'FocusGained', 'BufEnter', 'CursorHold' }, { pattern = '*', callback = function() vim.cmd('silent! checktime') end } },
	{ 'FileChangedShellPost', {
		pattern = '*',
		callback = function()
			print(
				'File changed on disk. Reloaded.')
		end
	} },
}

-- 一括で自動コマンドを作成
for _, autocmd in ipairs(autocmds) do
	autocmd.group = autocmd_group
	vim.api.nvim_create_autocmd(autocmd[1], autocmd[2])
end


-- カラースキームを設定
local function setup_colorscheme()
	local hostname = vim.fn.hostname()
	local colorscheme_map = {
		['pop-os'] = { scheme = 'iceberg', termguicolors = true },
		['tekkamelon-pcg-2c7n'] = { scheme = 'default', termguicolors = false }
	}

	local config = colorscheme_map[hostname] or { scheme = 'industry', termguicolors = true }
	vim.cmd.colorscheme(config.scheme)
	vim.opt.termguicolors = config.termguicolors
end

setup_colorscheme()

-- ヤンク時のハイライトの設定
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
	end
})

-- キーマップ設定を読み込み
require('keymaps.general')

-- プラグインの設定を読み込み
require('plugins')
