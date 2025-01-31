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

-- "options"内の左辺を"let",右辺を"status"にそれぞれ代入しループ
for let, status in pairs(options) do

	vim.g[let] = status

end

-- 拡張子ごとのfiletypeの設定
-- 各種設定ファイル
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*conf*' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '*conf*' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '.*rc' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '.*rc' , command = 'set filetype=conf',})

-- シェルの設定ファイル
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '.*shrc' , command = 'set filetype=sh',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '.*shrc' , command = 'set filetype=sh',})

-- テンプレート
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.sh' , command = '0r $HOME/Templates/sh.txt',})
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.awk' , command = '0r $HOME/Templates/awk.txt',})
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.py' , command = '0r $HOME/Templates/python.txt',})
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.c' , command = '0r $HOME/Templates/c.txt',})

-- vim.optの設定
-- "vim.opt"をテーブルで設定
local options = {

	termguicolors = true,

	background = 'dark',

	number = true,

	-- tabの幅を4に設定
	tabstop = 4,
	shiftwidth = 4,

	-- 分割方向を下と右に設定
	splitbelow = true,
	splitright = true,

	-- swapファイルを別ディレクトリに作成
	directory = '/tmp',

	cursorline = true,

}

-- "options"内の左辺を"set",右辺を"str"にそれぞれ代入しループ
for set, str in pairs(options) do

	vim.opt[set] = str

end

-- カラースキームの設定
-- ホスト名が"pop-os"の場合は真,そうでない場合は偽
if vim.fn.hostname() == "pop-os" then

	vim.cmd.colorscheme "iceberg"

-- 偽の場合はホスト名を確認,"tekkamelon-pcg-2c7n"の場合は真,そうでない場合は偽
elseif vim.fn.hostname() == "tekkamelon-pcg-2c7n" then

	vim.cmd.colorscheme "default"
	vim.opt.termguicolors = false

else

	vim.cmd.colorscheme "industry"

end

-- ヤンクした範囲のハイライト
-- ノーマルモード
vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })

-- ビジュアルモード
vim.cmd([[

	au TextYankPost * silent! lua vim.highlight.on_yank {higroup = "IncSearch", timeout = 200, on_visual = true}

]])

-- ターミナルの設定 
-- ターミナルノーマルモードへの移行
vim.keymap.set('t' , '<C-w><C-n>' , [[<C-\><C-n>]] , {noremap = true})

-- ターミナル起動時に行番号を非表示
vim.api.nvim_create_autocmd('TermOpen' , {pattern = '*' , command = 'setlocal norelativenumber',})
vim.api.nvim_create_autocmd('TermOpen' , {pattern = '*' , command = 'setlocal nonumber',})

-- "Bterm"コマンドの設定,ターミナルを下画面に高さを7行分下げた状態で起動
vim.api.nvim_create_user_command('Bterm' , 'split | resize -7 | terminal', { nargs = 0 })

-- "Vterm"の設定,ターミナルを右半分に起動
vim.api.nvim_create_user_command('Vterm' , 'vsplit | terminal', { nargs = 0 })

-- leaderの設定 
vim.g.mapleader = " "

-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then

	require('vscode-neovim_set')

else

	-- 偽の場合のキーマップ
	-- 保存,終了
	vim.keymap.set('n' , '<leader>w' , ':w<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>W' , ':wq<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>q' , ':q<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>Q' , ':q!<CR>' , {noremap = true})

	-- バッファの切り替え
	vim.keymap.set('n' , '<leader>j' , ':bprev<CR>' , {noremap = true})
	vim.keymap.set('n' , '<leader>k' , ':bnext<CR>' , {noremap = true})

end
-- leaderの設定ここまで 

-- ビジュアルモード時に"$"で改行を含めないようにする
vim.keymap.set('v' , '$' , 'g_' , {remap = true})

-- プラグインの設定を読み込み
require('plugin_settings')

