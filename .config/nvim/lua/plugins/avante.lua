-- avante.lua
-- Neovim >= 0.11.0

if not vim.g.vscode then
	require('avante').setup{
		opts = {
			provider = "copilot",
			auto_suggestions_provider = "copilot",

			-- 動作設定
			behaviour = {
				auto_suggestions = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
				minimize_diff = true,
			},

			selector = {
				provider = "telescope",
			},

			-- ウィンドウ設定
			windows = {
				wrap = true,
			},
		},
	}
end
