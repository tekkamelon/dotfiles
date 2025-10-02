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

	require('mason-lspconfig').setup({

		handlers = {

			function(server_name)

				lspconfig[server_name].setup{

					capabilities = capabilities,

					-- 診断設定をここにオーバーライド可能(必要に応じて)
				}

			end,

		}

	})

end
