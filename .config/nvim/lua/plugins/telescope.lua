if vim.g.vscode then return end

require("telescope").setup({
	defaults = {
		prompt_prefix = " 🔎 ",
		selection_caret = " ➤	 ",
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})

require("telescope").load_extension("ui-select")

require("plugins.telescope-avante")
