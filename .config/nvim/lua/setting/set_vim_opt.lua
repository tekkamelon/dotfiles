-- set_vim_opt.lua
-- vim.optの設定

-- "vim.opt"をテーブルで設定
local options = {

	-- 行番号を表示
	number = true,

	-- tabの幅を4に設定
	tabstop = 4,
	shiftwidth = 4,

	-- 分割方向を下と右に設定
	splitbelow = true,
	splitright = true,

	-- swapファイルを別ディレクトリに作成
	directory = '/tmp',

}

-- "options"内の左辺を"set",右辺を"str"にそれぞれ代入しループ
for set, str in pairs(options) do

  vim.opt[set] = str

end
