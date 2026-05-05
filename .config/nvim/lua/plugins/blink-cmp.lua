-- blink-cmp
-- Neovim >= 0.10.0

if vim.g.vscode then return end

-- mini.iconsからアイコンとハイライトを取得する関数
local get_mini_icon = function(ctx)
	-- Pathソースの場合はファイルタイプに応じたアイコンを取得
	if vim.tbl_contains({ "Path" }, ctx.source_name) then
		local is_unknown_type = vim.tbl_contains(
			{ "link", "socket", "fifo", "char", "block", "unknown" },
			ctx.item.data.type
		)
		local mini_icon, mini_hl, _ = require("mini.icons").get(
			is_unknown_type and "os" or ctx.item.data.type,
			is_unknown_type and "" or ctx.label
		)
		if mini_icon then
			return mini_icon, mini_hl
		end
	end
	-- LSPの種類に応じたアイコンを取得
	local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", ctx.kind)
	return mini_icon, mini_hl
end

require("blink.cmp").setup({
	-- Enterで補完を確定
	keymap = { preset = "enter" },
	completion = {
		-- ドキュメントを自動表示
		documentation = { auto_show = true },
		list = { selection = { preselect = false, auto_insert = true } },
		menu = {
			draw = {
				components = {
					kind_icon = {
						-- アイコンのテキストを取得
						text = function(ctx)
							local mini_icon, _ = get_mini_icon(ctx)
							return mini_icon
						end,
						-- アイコンのハイライトを取得
						highlight = function(ctx)
							local _, mini_hl = get_mini_icon(ctx)
							return mini_hl
						end,
					},
					kind = {
						-- 種類のハイライトを取得
						highlight = function(ctx)
							local _, mini_hl = get_mini_icon(ctx)
							return mini_hl
						end,
					},
				},
			},
		},
	},
	sources = {
		-- 使用する補完ソース
		default = { "avante", "lsp", "path", "snippets", "buffer" },
		providers = {
			avante = {
				module = "blink-cmp-avante",
				name = "Avante",
			},
		},
	},
	-- Rust実装を優先
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
