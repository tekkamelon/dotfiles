-- pop-os用のプラグインの設定

vim.cmd('packadd vim-jetpack')

require('jetpack.paq'){

	{'tani/vim-jetpack' , opt = 1},

	-- キャッシュなどの高速化
	'lewis6991/impatient.nvim',

	-- vim script製プラグイン
	'unblevable/quick-scope',
	'lambdalisue/fern.vim',
	'lambdalisue/fern-hijack.vim',
	'thinca/vim-partedit',
	'haya14busa/vim-edgemotion',

	-- lua製プラグイン
	'ojroques/nvim-hardline',
	'akinsho/toggleterm.nvim',
	'nvim-lua/plenary.nvim',
	'nvim-telescope/telescope.nvim',
	'glacambre/firenvim',

	-- mini.nvimのコンポーネント
	'echasnovski/mini.pairs',
	'echasnovski/mini.completion',
	'echasnovski/mini.comment',
	'echasnovski/mini.surround',
	'echasnovski/mini.jump2d',
	'echasnovski/mini.indentscope',

	-- lspの設定
	'neovim/nvim-lspconfig',
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',

}

-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then

	-- 真の場合は何もしない

else

	-- mini.indentscopeの設定
	require('mini.indentscope').setup{}

end
