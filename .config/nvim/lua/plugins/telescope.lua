if vim.g.vscode then return end
require("telescope").setup({
	defaults = {
		-- プロンプトの設定
		prompt_prefix = " 🔎 ",
		selection_caret = " ➤	 ",
	},
	-- telescope-ui-selectの設定
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")
