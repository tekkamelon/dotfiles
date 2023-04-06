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
vim.opt.cursorline= true

-- 分割方向を下と右
vim.opt.splitbelow = true
vim.opt.splitright= true

-- ====== leaderをspaceに設定 ====== 
vim.g.mapleader = " "
