-- img-clip.lua
-- Neovim >= 0.11.0
-- avante.nvimと連携して画像を貼り付ける設定

require("img-clip").setup({
	default = {
		-- 画像をbase64としてエンベッド(avante向け)
		embed_image_as_base64 = false,
		-- ファイル名の確認プロンプトを非表示
		prompt_for_file_name = false,
		-- ドラッグ&ドロップ設定
		drag_and_drop = {
			insert_mode = true,
		},
	},

	-- avante.nvim用のファイルタイプ別設定
	-- Avanteバッファでは画像をbase64で埋め込む
	filetypes = {
		Avante = {
			embed_image_as_base64 = true,
		},
	},
})
