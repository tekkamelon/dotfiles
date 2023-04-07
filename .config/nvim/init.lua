-- カラースキーム
vim.cmd('colorscheme industry')

-- 24bitカラーを有効
vim.opt.termguicolors = true

-- 背景色をダークモード
vim.opt.background = 'dark'

-- 行番号を表示
vim.opt.number = true

-- tabの幅を4に設定
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- カーソルラインを表示
vim.opt.cursorline = true

-- カーソルラインの設定
vim.cmd([[

	" 一度カーソルラインをリセット
	hi clear CursorLine

	" カーソルラインをアンダーラインに設定
	hi CursorLine gui=underline cterm=underline

	" ターミナル起動時に行番号を非表示
	autocmd TermOpen * setlocal norelativenumber
	autocmd TermOpen * setlocal nonumber

]])

-- ターミナルノーマルモードへの移行
vim.keymap.set('t', '<C-w><C-n>' , [[<C-\><C-n>]] , {noremap=true})

-- swapファイルを別ディレクトリに作成
vim.opt.directory = '/tmp'

-- 分割方向を下と右
vim.opt.splitbelow = true
vim.opt.splitright= true

-- ====== leaderをspaceに設定 ====== 
vim.g.mapleader = " "
