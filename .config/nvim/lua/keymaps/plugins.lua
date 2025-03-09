
local vim_keymap = vim.keymap.set
local options = { noremap = true }

local kmaps = {

	-- vim-edgemotion
	-- 下キーで1つ下のコードブロック
	{ '<C-j>' , '<Plug>(edgemotion-j)' , options },
	{ '<C-Down>' , '<Plug>(edgemotion-j)', options },
	-- 上キーで1つ上のコードブロック
	{ '<C-k>' , '<Plug>(edgemotion-k)' , options },
	{ '<C-Up>' , '<Plug>(edgemotion-k)', options },

	-- jumpcursor
	{ '<leader>h' , '<Plug>(jumpcursor-jump)' , options },

	-- mini.comment
	-- コメントアウト
	{ '<leader>g' , 'gcc' , {remap = true }},

}

-- テーブルの内容をループし代入
for _, kmaps in pairs(kmaps) do

	vim_keymap({'n' , 'v'} , kmaps[1] , kmaps[2] , kmaps[3])

end

