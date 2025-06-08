-- neocodeium.lua
-- neovim >= 0.10.0


-- プラグインの読み込み
local neocodeium = require("neocodeium")

-- 基本設定を初期化
neocodeium.setup{

	filetypes = {

		-- markdownでの保管を無効化
		markdown = false

	},

}

-- キーマッピングの設定
-- サジェストの受け入れ
vim.keymap.set("i", "<Tab>", function()

	-- サジェストの表示状態
	local suggest = neocodeium.visible()

	-- サジェストを表示している場合
	if suggest then

		neocodeium.accept()

	else

		-- サジェストされていない場合はタブを入力
		-- キーコードをneovimが解釈可能な形式に変換
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)

	end

end, { expr = true, silent = true })

-- 単語単位のサジェストの受け入れ
vim.keymap.set("i", "<C-s>", neocodeium.accept_word)


-- 次の候補
vim.keymap.set("i", "<C-f>", function()

  neocodeium.cycle(1)

end)

-- 前の候補
vim.keymap.set("i", "<C-F>", function()

  neocodeium.cycle(-1)

end)

-- サジェストのキャンセル
vim.keymap.set("i", "<C-q>", neocodeium.clear)

