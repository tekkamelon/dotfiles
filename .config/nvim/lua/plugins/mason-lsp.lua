-- mason-lspconfig


if not vim.g.vscode then

	-- lspconfigを読み込み
	local lspconfig = require('lspconfig')

	-- LSPのクライアントの設定
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	require('mason-lspconfig').setup_handlers{

		function(server_name)

			lspconfig[server_name].setup{

				capabilities = capabilities,

			}

		end,

	}

end

