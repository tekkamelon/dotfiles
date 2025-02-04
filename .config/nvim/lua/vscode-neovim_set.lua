-- vscode-neovim_set.lua

-- "vscode-neovim"の場合のキーマップ
-- ローカル変数を宣言
local vim_keymap = vim.keymap.set
local options = { noremap = true }

local kmaps = {

	-- 保存,終了
	{ '<leader>w' , ":call VSCodeCall('workbench.action.files.save')<CR>" },
	{ '<leader>W' , ":call VSCodeCall('workbench.action.files.saveALL')<CR>" },
	{ '<leader>q' , ":call VSCodeCall('workbench.action.closeActiveEditor')<CR>" },
	{ '<leader>Q' , ":call VSCodeCall('workbench.action.closeAllEditors')<CR>" },

	-- バッファの切り替え
	{ '<leader>j' , ":call VSCodeCall('workbench.action.previousEditor')<CR>" },
	{ '<leader>k' , ":call VSCodeCall('workbench.action.nextEditor')<CR>" },

	-- ファイルを開く
	{ '<leader>ff' , ":call VSCodeCall('workbench.action.files.openFile')<CR>" },

	-- フォルダーを開く
	{ '<leader>fh' , ":call VSCodeCall('workbench.action.files.openFolder')<CR>" },

	-- ターミナルを起動
	{ '<leader>tt' , ":call VSCodeCall('workbench.action.terminal.toggleTerminal')<CR>" },

}

-- テーブルの内容をループし代入
for _, kmaps in pairs(kmaps) do

	vim_keymap('n' , kmaps[1] , kmaps[2] , options)

end

