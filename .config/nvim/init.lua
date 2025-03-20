-- init.lua
-- neovim >= 0.9.0


-- 標準プラグインの読込停止
-- "vim.g"をテーブルで設定
local options = {

	did_install_default_menus = 1,
	did_load_ftplugin = 1,
	loaded_2html_plugin = 1,
	loaded_getscript = 1,
	loaded_getscriptPlugin = 1,
	loaded_gzip = 1,
	loaded_man = 1,
	loaded_matchit = 1,
	loaded_netrw = 1,
	loaded_netrwFileHandlers = 1,
	loaded_netrwPlugin = 1,
	loaded_netrwSettings = 1,
	loaded_remote_plugins = 1,
	loaded_rrhelper = 1,
	loaded_shada_plugin = 1,
	loaded_spellfile_plugin = 1,
	loaded_tarPlugin = 1,
	loaded_tutor_mode_plugin = 1,
	loaded_vimball = 1,
	loaded_vimballPlugin = 1,
	loaded_zipPlugin = 1,
	skip_loading_mswin = 1,

}

-- "options"内のkeyを"let",valueを"status"にそれぞれ代入しループ
for let, status in pairs(options) do

	vim.g[let] = status

end


-- 自動コマンドの設定
local create_autocmd = vim.api.nvim_create_autocmd

-- バッファ上のファイルの種類
local buf_nr = {'BufNewFile', 'BufRead'}
local buf_n = 'BufNewFile'

local template_files = {

	-- filetypeの設定
	{buf_nr, {pattern = {'*conf*', '*rc' }, command = 'set filetype=conf'}},
	{buf_nr, {pattern = '.*shrc', command = 'set filetype=sh'}},
	{buf_nr, {pattern = '.vimrc', command = 'set filetype=vim'}},
	{buf_nr, {pattern = '.tmux.conf', command = 'set filetype=tmux'}},

	-- テンプレートの読み込み
    {buf_n, {pattern = '*.sh', command = [[0r $HOME/Templates/sh.txt]]}},
    {buf_n, {pattern = '*.awk', command = [[0r $HOME/Templates/awk.txt]]}},
    {buf_n, {pattern = '*.py', command = [[0r $HOME/Templates/python.txt]]}},
    {buf_n, {pattern = '*.c', command = [[0r $HOME/Templates/c.txt]]}},

	-- ターミナル起動時に行番号を非表示
	{'TermOpen', {pattern = '*', command = 'setlocal norelativenumber | setlocal nonumber'}}

}

for _, table in ipairs(template_files) do

	create_autocmd(table[1], table[2])

end


-- vim.optの設定
-- "vim.opt"をテーブルで設定
local vim_opt = {

	termguicolors = true,
	background = 'dark',
	number = true,
	cursorline = true,

	-- tabの幅を4に設定
	tabstop = 4,
	shiftwidth = 4,

	-- 分割方向を下と右に設定
	splitbelow = true,
	splitright = true,

	-- swapファイルを別ディレクトリに作成
	directory = '/tmp',

}

-- "options"内のkeyを"set",valueを"str"にそれぞれ代入しループ
for set, str in pairs(vim_opt) do

	vim.opt[set] = str

end

-- カラースキームの設定
-- ホスト名に基づくカラースキーム設定をテーブルで管理
local colorscheme_settings = {

    ['default'] = {scheme = 'industry', termguicolors = true},
    ['pop-os'] = {scheme = 'iceberg', termguicolors = true},
    ['tekkamelon-pcg-2c7n'] = {scheme = 'default', termguicolors = false}

}

-- "hostname"に現在のマシンのホスト名を代入
local hostname = vim.fn.hostname()

-- "settings"にホスト名に応じたテーブルの値を代入
local settings = colorscheme_settings[hostname] or colorscheme_settings['default']

-- 設定を適用
vim.cmd.colorscheme(settings.scheme)
vim.opt.termguicolors = settings.termguicolors


-- ヤンクした範囲のハイライト
-- ノーマルモード
vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })

-- ビジュアルモード
vim.cmd([[ au TextYankPost * silent! ]])
vim.highlight.on_yank{higroup = "IncSearch", timeout = 200, on_visual = true}

-- leaderの設定 
vim.g.mapleader = " "

-- キーマップ設定を読み込み
require('keymaps.general')

-- プラグインの設定を読み込み
require('plugins')

