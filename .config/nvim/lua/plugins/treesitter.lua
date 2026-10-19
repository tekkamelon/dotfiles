-- treesitter.lua
-- nvim-treesitter mainブランチ用 (Neovim >= 0.12)
-- masterブランチはfrozenでありNeovim 0.12をサポートしないためmainを使用する

-- vscodeから起動していなければ真
if not vim.g.vscode then

	-- noice/avante/render-markdownが使用するパーサー
	local ensure_installed = {
		"bash",
		"lua",
		"markdown",
		"markdown_inline",
		"regex",
		"vim",
		"vimdoc",
		"python",
		"javascript",
	}

	require("nvim-treesitter").setup({})

	-- 不足しているパーサーを非同期で導入 (導入済みなら何もしない)
	require("nvim-treesitter").install(ensure_installed)

	-- treesitterによるハイライトを有効化
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("UserTreesitterHighlight", { clear = true }),
		callback = function(args)
			local buf = args.buf
			local filetype = vim.bo[buf].filetype
			-- Avante系のバッファーはmarkdownとして扱う
			local lang = (filetype == "Avante" or filetype == "AvanteInput") and "markdown"
				or vim.treesitter.language.get_lang(filetype)
			if not lang or lang == "" then
				return
			end
			-- パーサーがなければ何もしない
			if not pcall(vim.treesitter.language.add, lang) then
				return
			end
			pcall(vim.treesitter.start, buf, lang)
		end,
	})

end
