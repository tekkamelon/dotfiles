-- blink-cmp
-- Neovim >= 0.10.0

if vim.g.vscode then return end

require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = false },
		list = { selection = { preselect = false, auto_insert = true } },
	},
	sources = {
		default = { "avante", "lsp", "path", "snippets", "buffer" },
		providers = {
			avante = {
				module = "blink-cmp-avante",
				name = "Avante",
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})