-- neocodeium.lua


-- プラグインの読み込み
local neocodeium = require("neocodeium")

-- 基本設定を初期化
neocodeium.setup()

-- キーマッピングの設定
-- 単語単位のサジェストの受け入れ
vim.keymap.set("i", "<C-s>", neocodeium.accept_word)

-- サジェストの受け入れ
vim.keymap.set("i", "<Tab>", neocodeium.accept)

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

