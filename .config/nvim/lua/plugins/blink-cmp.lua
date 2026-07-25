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
		default = { "lsp", "path", "snippets", "buffer" },
		-- agentic プロンプト用: スラッシュコマンドと @ ファイル参照
		per_filetype = {
			AgenticInput = { "agentic_slash", "agentic_at" },
		},
		providers = {
			agentic_slash = {
				module = "blink.cmp.sources.complete_func",
				name = "AgenticSlash",
				enabled = function()
					local cursor = vim.api.nvim_win_get_cursor(0)
					if cursor[1] ~= 1 then return false end
					local before = vim.api.nvim_get_current_line():sub(1, cursor[2])
					return before:match("^/[^%s]*$") ~= nil
				end,
				opts = {
					complete_func = function()
						return "v:lua.require'agentic.acp.slash_commands'.complete_func"
					end,
				},
				transform_items = function(_, items)
					for _, item in ipairs(items) do
						if item.labelDetails then
							item.labelDetails.detail = nil
						end
					end
					return items
				end,
			},
			agentic_at = {
				module = "blink.cmp.sources.complete_func",
				name = "AgenticAt",
				enabled = function()
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local before = vim.api.nvim_get_current_line():sub(1, col)
					return (before:match("^@[^%s]*$") or before:match("[%s]@[^%s]*$")) ~= nil
				end,
				opts = {
					complete_func = function()
						return "v:lua.require'agentic.ui.file_picker'.complete_func"
					end,
				},
				transform_items = function(_, items)
					for _, item in ipairs(items) do
						if item.labelDetails then
							item.labelDetails.detail = nil
						end
					end
					return items
				end,
			},
		},
	},
	-- Rust実装を優先
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
