-- plugins.lua


-- キーマップの設定
-- ローカル変数を宣言
local vim_keymap = vim.keymap.set
local options = { noremap = true, silent = true }

-- 関数を宣言
local M = {}

-- vscode-neovimから呼び出した場合の設定
M.setup_vscode = function()
	local kmaps = {

		-- vim-edgemotion
		-- 下キーで1つ下のコードブロック
		{ '<C-j>',     '<Plug>(edgemotion-j)' },
		{ '<C-Down>',  '<Plug>(edgemotion-j)' },
		-- 上キーで1つ上のコードブロック
		{ '<C-l>',     '<Plug>(edgemotion-k)' },
		{ '<C-Up>',    '<Plug>(edgemotion-k)' },

		-- mini.comment
		-- コメントアウト
		{ '<leader>g', 'gcc',                 { remap = true } },

	}

	-- テーブルの内容をループし代入
	for _, kmap in ipairs(kmaps) do
		vim_keymap({ 'n', 'v' }, kmap[1], kmap[2], kmap[3] or options)
	end
end

-- 通常のneovimから呼び出した場合の設定
M.setup_neovim = function()
	-- キーマップ設定のテーブルを作成
	local kmaps = {

		-- vim-edgemotion
		-- 下キーで1つ下のコードブロック
		{ { 'n', 'v' }, '<C-j>',      '<Plug>(edgemotion-j)' },
		{ { 'n', 'v' }, '<C-Down>',   '<Plug>(edgemotion-j)' },
		-- 上キーで1つ上のコードブロック
		{ { 'n', 'v' }, '<C-k>',      '<Plug>(edgemotion-k)' },
		{ { 'n', 'v' }, '<C-Up>',     '<Plug>(edgemotion-k)' },

		-- jumpcursor
		{ { 'n', 'v' }, '<leader>h',  '<Plug>(jumpcursor-jump)' },

		-- mini.comment
		-- コメントアウト
		{ { 'n', 'v' }, '<leader>g',  'gcc',                                                                                   { remap = true } },

		-- vim-partedit
		-- ビジュアルモード時にコマンドを表示
		{ 'v',          '<leader>e',  ':Partedit -opener new -filetype ' },

		-- telescope
		-- 隠しファイルを含めず検索
		{ 'n',          '<leader>ff', ':Telescope find_files hidden=false previewer=false theme=get_dropdown<CR>' },
		-- 隠しファイルを含め検索
		{ 'n',          '<leader>fh', ':Telescope find_files hidden=true previewer=false theme=get_dropdown<CR>' },
		-- バッファを検索
		{ 'n',          '<leader>fb', ':Telescope buffers previewer=false theme=get_dropdown<CR>' },
		-- レジスタ一覧を検索
		{ 'n',          '<leader>fr', ':Telescope registers<CR>' },
		-- ファイル内文字列を検索
		-- "$ sudo apt install ripgrep -y"で使用可能
		{ 'n',          '<leader>fg', ':Telescope live_grep hidden=true previewer=true theme=get_dropdown<CR>' },
		-- カレントバッファ内文字列を検索
		{ 'n',          '<leader>fc', ':Telescope current_buffer_fuzzy_find hidden=true previewer=true theme=get_dropdown<CR>' },
		-- コマンドを検索
		{ 'n',          '<leader>fl', ':Telescope commands hidden=false previewer=false<CR>' },
		-- コマンド履歴
		{ 'n',          '<leader>fH', ':Telescope command_history theme=get_dropdown<CR>' },

		-- toggleterm
		-- 下方,右側,フロートウィンドウのターミナルのトグル
		{ 'n',          '<leader>tt', ':ToggleTerm size=20 direction=horizontal<CR>' },
		{ 'n',          '<leader>tv', ':ToggleTerm size=60 direction=vertical<CR>' },
		{ 'n',          '<leader>tf', ':ToggleTerm direction=float<CR>' },
		-- ノーマルモード時に現在カーソルのある行を,ビジュアルモード時に選択範囲をターミナルに送る
		{ 'n',          '<leader>ts', ':ToggleTermSendCurrentLine<CR>' },
		{ 'v',          '<leader>ts', ':ToggleTermSendVisualLines<CR>' },

		-- hop
		-- 全ウィンドウのすべての文字にラベルを付ける
		{ 'n',          '<leader>h',  ':HopAnywhereMW<CR>' },

		-- avante
		-- チャットバッファをトグル
		{ 'n',          '<leader>cc', ':AvanteToggle<CR>' },
		-- LLMを変更
		{ 'n',          '<leader>am', ':AvanteModels<CR>' },
		-- チャット内容をクリア
		{ 'n',          '<leader>ar', ':AvanteClear<CR>' },

	}

	-- テーブルの内容をループし代入
	for _, kmap in ipairs(kmaps) do
		vim_keymap(kmap[1], kmap[2], kmap[3], kmap[4] or options)
	end

	-- img-clipとの連携の設定
	-- クリップボードから画像を貼り付けるためのキーマップを設定
	vim_keymap({ "n", "i" }, "<leader>p", function()
		-- ファイルタイプがAvanteInputまたはAvanteの場合,Avanteのクリップボード機能を使用
		if vim.bo.filetype == "AvanteInput" or vim.bo.filetype == "Avante" then
			require("avante.clipboard").paste_image()
		else
			-- それ以外の場合はimg-clipプラグインを使用して画像を貼り付け
			require("img-clip").paste_image()
		end
	end, { desc = "Paste image from clipboard" })
end

-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then
	M.setup_vscode()
else
	M.setup_neovim()
end
