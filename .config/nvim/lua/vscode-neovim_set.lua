-- vscode-neovim_set.lua

-- "vscode-neovim"の場合のキーマップ

-- 保存,終了
vim.keymap.set('n' , '<leader>w' , ":call VSCodeCall('workbench.action.files.save')<CR>" , { noremap = true})
vim.keymap.set('n' , '<leader>W' , ":call VSCodeCall('workbench.action.files.saveALL')<CR>" , { noremap = true})
vim.keymap.set('n' , '<leader>q' , ":call VSCodeCall('workbench.action.closeActiveEditor')<CR>" , { noremap = true})
vim.keymap.set('n' , '<leader>Q' , ":call VSCodeCall('workbench.action.closeAllEditors')<CR>" , { noremap = true})

-- バッファの切り替え
vim.keymap.set('n' , '<leader>j' , ":call VSCodeCall('workbench.action.previousEditor')<CR>" , { noremap = true})
vim.keymap.set('n' , '<leader>k' , ":call VSCodeCall('workbench.action.nextEditor')<CR>" , { noremap = true})

-- ファイルを開く
vim.keymap.set('n' , '<leader>ff' , ":call VSCodeCall('workbench.action.files.openFile')<CR>" , { noremap = true})

-- フォルダーを開く
vim.keymap.set('n' , '<leader>fh' , ":call VSCodeCall('workbench.action.files.openFolder')<CR>" , { noremap = true})

-- ターミナルを起動
vim.keymap.set('n' , '<leader>tt' , ":call VSCodeCall('workbench.action.terminal.toggleTerminal')<CR>" , { noremap = true})

