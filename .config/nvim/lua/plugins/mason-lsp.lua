-- mason-lspconfig
-- Neovim >= 0.11.0

if vim.g.vscode then return end

local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- 診断設定をグローバルに定義
vim.diagnostic.config({
	virtual_text = {
		prefix = '●',
		source = "if_many",
		severity_sort = true,
	},
	float = {
		border = 'rounded',
		source = true,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- LSP Attach時の設定
local function on_lsp_attach(args)
	local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

	-- 補完の設定
	if client:supports_method('textDocument/completion') then
		-- ASCII文字32-126をトリガーキャラクタに設定
		local trigger_chars = {}
		for i = 32, 126 do trigger_chars[#trigger_chars + 1] = string.char(i) end
		client.server_capabilities.completionProvider.triggerCharacters = trigger_chars
		-- 補完を有効化
		vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
	end

	-- フォーマット設定
	if not client:supports_method('textDocument/willSaveWaitUntil') and
		client:supports_method('textDocument/formatting') then
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 3000 })
			end,
		})
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = on_lsp_attach,
})

-- Mason-lspconfig設定
require('mason-lspconfig').setup({
	handlers = {
		function(server_name)
			lspconfig[server_name].setup {
				capabilities = capabilities,
			}
		end,
	}
})
