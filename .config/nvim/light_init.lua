-- light_init.lua

-- ====== 標準プラグインの読込停止 ======
-- "vim.g"をテーブルで設定
local options = {

	did_install_default_menus = 1,
	loaded_2html_plugin = 1,
	loaded_getscript = 1,
	loaded_getscriptPlugin = 1,
	loaded_gzip = 1,
	loaded_man = 1,
	loaded_matchit = 1,
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
-- ====== 標準プラグインの読込停止ここまで ======


-- ヤンクした範囲のハイライト,ビジュアルモード時にオフ
vim.cmd([[

	au TextYankPost * silent! lua vim.highlight.on_yank {higroup = "IncSearch", timeout = 700 , on_visual = false}

]])

-- 行番号を表示
vim.opt.number = true

-- tabの幅を4に設定
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- 背景色をダークモードに設定
vim.opt.background = 'dark' 

-- ビジュアルモード時に"$"で改行を含めないようにする
vim.keymap.set('v' , '$' , 'g_' , {remap = true})

-- 分割方向を下と右に設定
vim.opt.splitbelow = true
vim.opt.splitright= true

-- swapファイルを別ディレクトリに作成
vim.opt.directory = '/tmp'

-- カーソルラインをアンダーラインに設定
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine' , { underline = true })

-- カラースキームをindustryに設定
vim.cmd([[colorscheme industry]])


-- ====== ターミナルの設定 ====== 
-- ターミナルノーマルモードへの移行
vim.keymap.set('t' , '<C-w><C-n>' , [[<C-\><C-n>]] , {noremap = true})

-- ターミナル起動時に行番号を非表示
vim.api.nvim_create_autocmd('TermOpen' , {pattern = '*' , command = 'setlocal norelativenumber',})
vim.api.nvim_create_autocmd('TermOpen' , {pattern = '*' , command = 'setlocal nonumber',})

-- "Bterm"コマンドの設定,ターミナルを下画面に高さを7行分下げた状態で起動
vim.api.nvim_create_user_command('Bterm' , 'split | resize -7 | terminal', { nargs = 0 })

-- "Vterm"の設定,ターミナルを右半分に起動
vim.api.nvim_create_user_command('Vterm' , 'vsplit | terminal', { nargs = 0 })
-- ====== ターミナルの設定の終了 ====== 


-- ====== leaderの設定 ====== 
-- leaderをspaceに設定  
vim.g.mapleader = " "

-- 保存,終了
vim.keymap.set('n' , '<leader>w' , ':w<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>W' , ':wq<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>q' , ':q<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>Q' , ':q!<CR>' , {noremap = true})

-- バッファの切り替え
vim.keymap.set('n' , '<leader>j' , ':bprev<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>k' , ':bnext<CR>' , {noremap = true})

-- ターミナルの起動
vim.keymap.set('n' , '<leader>tt' , ':Bterm<CR>' , {noremap = true})
vim.keymap.set('n' , '<leader>tv' , ':Vterm<CR>' , {noremap = true})
-- ====== leaderの設定ここまで ====== 

