-- mason-lsp.lua
-- Neovim >= 0.11.0
-- 標準API vim.lsp.config / vim.lsp.enable を使用
-- サーバー定義は nvim-lspconfig が提供する lsp/*.lua を利用

if vim.g.vscode then return end

-- blink.cmpが未読込でも落ちないようにcapabilitiesを取得
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink and blink.get_lsp_capabilities then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

-- 全サーバー共通設定
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- サーバー固有設定があればここに記述
-- 例: vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- 診断設定をグローバルに定義
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
		severity_sort = true,
	},
	float = {
		border = "rounded",
		source = true,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- LSP Attach時の設定
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- フォーマット設定
		if not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 3000 })
				end,
			})
		end
	end,
})

-- masonで導入済みのサーバーを標準APIで自動有効化
-- mason-lspconfig v2系: automatic_enable = true で vim.lsp.enable() 相当
require("mason-lspconfig").setup({
	automatic_enable = true,
})
