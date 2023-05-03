-- set_filetype.lua
-- 拡張子ごとのfiletypeの設定

-- *.cgiの場合
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.cgi' , command = 'set filetype=sh',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '*.cgi' , command = 'set filetype=sh',})

-- *.scadの場合
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*.scad' , command = 'set filetype=openscad',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '*.scad' , command = 'set filetype=openscad',})

-- 各種設定ファイル
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '*conf*' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '*conf*' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '.*rc' , command = 'set filetype=conf',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '.*rc' , command = 'set filetype=conf',})

-- シェルの設定ファイル
vim.api.nvim_create_autocmd('BufNewFile' , {pattern = '.*shrc' , command = 'set filetype=sh',})
vim.api.nvim_create_autocmd('BufRead' , {pattern = '.*shrc' , command = 'set filetype=sh',})
