-- mason-lspconfig
-- Neovim >= 0.11.0


if not vim.g.vscode then
	-- lspconfigを読み込み
	local lspconfig = require('lspconfig')

	-- LSPのクライアントの設定
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- 診断設定をグローバルに定義
	vim.diagnostic.config({
		virtual_text = {
			-- プレフィックスアイコン
			prefix = '●',
			-- ソースを表示(複数ある場合)
			source = "if_many",
			-- 深刻度でソート
			severity_sort = true,
		},
		-- フロートウィンドウの設定
		float = {
			border = 'rounded',
			source = true,
		},
		signs = true,
		-- サイン列を表示
		underline = true,
		-- アンダーライン
		update_in_insert = false,
		-- インサートモード中は更新せず
		severity_sort = true,
	})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("my.lsp", {}),
		callback = function(args)
			local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

			-- 補完の設定
			if client:supports_method('textDocument/completion') then
				-- 文字を入力する度に補完を表示(遅くなる可能性あり)
				local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
				client.server_capabilities.completionProvider.triggerCharacters = chars
				-- 補完を有効化
				vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			end

			-- フォーマット
			if not client:supports_method('textDocument/willSaveWaitUntil')
				and client:supports_method('textDocument/formatting') then
				vim.api.nvim_create_autocmd('BufWritePre', {
					group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
					buffer = args.buf,
					callback = function()
						vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 3000 })
					end,
				})
			end
		end,
	})

	require('mason-lspconfig').setup({
		handlers = {
			function(server_name)
				lspconfig[server_name].setup {
					capabilities = capabilities,
				}
			end,
		}
	})
end
