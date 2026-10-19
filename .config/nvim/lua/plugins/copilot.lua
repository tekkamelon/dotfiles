-- copilot.lua
-- Neovim >= 0.12.0
-- copilot.luaを標準のvim.lsp.inline_completionに置き換える設定
-- GitHub Copilot Language ServerをLSPクライアントとして起動し,
-- インライン補完(ゴーストテキスト)を標準機能で受け取る

if vim.g.vscode then return end

-- インライン補完を無効化するファイルタイプ
-- 旧copilot.luaのfiletype設定を踏襲
local disabled_filetypes = {
	AvanteInput = true,
	AvantePromptInput = true,
	AvanteSelectedFiles = true,
	AvanteSelectedCode = true,
	env = true,
}

-- copilot-language-serverの実行ファイルを解決
local function resolve_language_server()
	-- 1. ユーザーが明示指定したパス
	local custom = vim.g.copilot_language_server_path
	if type(custom) == "string" and custom ~= "" then
		return custom
	end

	-- 2. PATH上のcopilot-language-server
	local exe = vim.fn.exepath("copilot-language-server")
	if exe ~= "" then
		return exe
	end

	-- 3. copilot.luaが導入したキャッシュ (移行期間向け)
	local pattern = vim.fn.stdpath("data") .. "/copilot.lua/lsp/*/*/*/copilot-language-server"
	local found = vim.fn.glob(pattern, false, true)
	if #found > 0 then
		table.sort(found)
		return found[#found]
	end

	return nil
end

local server = resolve_language_server()
if not server then
	vim.notify(
		"copilot-language-serverが見つかりません。npm install --global @github/copilot-language-server を実行するか, vim.g.copilot_language_server_pathを設定してください。",
		vim.log.levels.WARN
	)
	return
end

-- Copilot用のLSP設定
vim.lsp.config("copilot", {
	cmd = { server, "--stdio" },

	-- プロジェクトルートを決定
	-- .gitが無い場合はカレントディレクトリを使い, 旧copilot.luaに近い挙動にする
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, { ".git" })
		on_dir(root or vim.fn.getcwd())
	end,

	init_options = {
		editorInfo = {
			name = "Neovim",
			version = tostring(vim.version()),
		},
		editorPluginInfo = {
			name = "Neovim",
			version = tostring(vim.version()),
		},
	},

	on_attach = function(client, bufnr)
		-- サインイン
		vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignIn", function()
			client:request("signIn", vim.empty_dict(), function(err, result)
				if err then
					vim.notify(err.message, vim.log.levels.ERROR)
					return
				end
				if not result then return end
				if result.status == "AlreadySignedIn" then
					vim.notify("Copilot: already signed in as " .. result.user .. ".")
					return
				end
				if result.userCode then
					vim.fn.setreg("+", result.userCode)
					vim.notify(
						"Copilot: " .. result.userCode .. " を " .. (result.verificationUri or "ブラウザ") .. " で入力してください。"
					)
				end
			end)
		end, { desc = "Sign in to GitHub Copilot" })

		-- サインアウト
		vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignOut", function()
			client:request("signOut", vim.empty_dict(), function(err, result)
				if err then
					vim.notify(err.message, vim.log.levels.ERROR)
				elseif result and result.status == "NotSignedIn" then
					vim.notify("Copilot: not signed in.")
				end
			end)
		end, { desc = "Sign out of GitHub Copilot" })
	end,
})

-- インライン補完の有効化とキーマップ
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.copilot", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "copilot" then
			return
		end

		local bufnr = args.buf

		-- 対象外のファイルタイプでは有効化しない
		if disabled_filetypes[vim.bo[bufnr].filetype] then
			return
		end

		-- サーバーがインライン補完に対応していなければ何もしない
		if not client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
			return
		end

		vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

		-- 次の候補
		-- <C-f>と<C-F>は同じキーコードになるため, copilot.luaの既定キーを使う
		vim.keymap.set("i", "<M-]>", function()
			vim.lsp.inline_completion.select({ count = 1 })
		end, { buffer = bufnr, desc = "次のインライン補完候補" })

		-- 前の候補
		vim.keymap.set("i", "<M-[>", function()
			vim.lsp.inline_completion.select({ count = -1 })
		end, { buffer = bufnr, desc = "前のインライン補完候補" })

		-- 候補を消す
		-- 標準にdismiss APIが無いため, 一旦無効化してから再度有効化する
		vim.keymap.set("i", "<C-q>", function()
			vim.lsp.inline_completion.enable(false, { bufnr = bufnr })
			vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
		end, { buffer = bufnr, desc = "インライン補完を消す" })
	end,
})

vim.lsp.enable("copilot")

-- 候補があれば確定し, 無ければ通常の<Tab>を入力
-- blink.cmpの<Tab>(スニペット移動)が後から設定された場合はそちらが優先される
vim.keymap.set("i", "<Tab>", function()
	if not vim.lsp.inline_completion.get() then
		return "<Tab>"
	end
end, { expr = true, silent = true, desc = "インライン補完を確定" })
