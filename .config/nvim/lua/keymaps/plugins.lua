-- general.lua


-- キーマップの設定
-- ローカル変数を宣言
local vim_keymap = vim.keymap.set
local options = { noremap = true }

-- vscode-neovimから起動した際に真,それ以外で偽
if vim.g.vscode then

	local kmaps = {

		-- vim-edgemotion
		-- 下キーで1つ下のコードブロック
		{ '<C-j>' , '<Plug>(edgemotion-j)' , options },
		{ '<C-Down>' , '<Plug>(edgemotion-j)', options },
		-- 上キーで1つ上のコードブロック
		{ '<C-l>' , '<Plug>(edgemotion-k)' , options },
		{ '<C-Up>' , '<Plug>(edgemotion-k)', options },

		-- jumpcursor
		{ '<leader>h' , '<Plug>(jumpcursor-jump)' , options },

		-- mini.comment
		-- コメントアウト
		{ '<leader>g' , 'gcc' , {remap = true }},

	}

	-- テーブルの内容をループし代入
	for _, kmaps in pairs(kmaps) do

		vim_keymap({'n' , 'v'} , kmaps[1] , kmaps[2] , kmaps[3])

	end

else

	-- copilot.luaの設定
	-- インサートモード時の<Tab>キーの動作を定義
	vim_keymap("i", '<Tab>', function()

		-- ローカル変数を宣言
		local suggest = require("copilot.suggestion")

			-- copilotがサジェストしていれば真
			if suggest.is_visible() then

				-- サジェストを受け入れ
				suggest.accept()

			else

				-- 通常の<Tab>キーの動作を実行
				vim.api.nvim_feedkeys(

					-- キーコードをneovimが理解可能な形式に変換
					vim.api.nvim_replace_termcodes("<Tab>" , true , false , true) , "n" , false

				)

			end

		end,

		{

			-- コマンドラインへの表示をオフ
			silent = true,

		}

	)

	-- mini.filesのトグルの設定
	local MiniFiles = require('mini.files')
	local minifiles_toggle = function()

		-- ファイラが開いていれば真
		if not MiniFiles.close()

			-- カレントバッファのディレクトリを表示
			then MiniFiles.open(vim.api.nvim_buf_get_name(0))

		end

	end

	local kmaps = {

		-- vim-edgemotion
		-- 下キーで1つ下のコードブロック
		{ {'n' , 'v'} , '<C-j>' , '<Plug>(edgemotion-j)' , options },
		{ {'n' , 'v'} , '<C-Down>' , '<Plug>(edgemotion-j)', options },
		-- 上キーで1つ上のコードブロック
		{ {'n' , 'v'} , '<C-k>' , '<Plug>(edgemotion-k)' , options },
		{ {'n' , 'v'} , '<C-Up>' , '<Plug>(edgemotion-k)', options },

		-- jumpcursor
		{ {'n' , 'v'} , '<leader>h' , '<Plug>(jumpcursor-jump)' , options },

		-- mini.comment
		-- コメントアウト
		{ {'n' , 'v'} , '<leader>g' , 'gcc' , {remap = true }},
		
		-- vim-partedit
		-- ビジュアルモード時にコマンドを表示
		{ 'v' , '<leader>e' , ':Partedit -opener new -filetype ' , options },

		-- telescope
		-- 隠しファイルを含めず検索
		{ 'n' , '<leader>ff' , ':Telescope find_files hidden=false previewer=false theme=get_dropdown<CR>' , options },
		-- 隠しファイルを含め検索
		{ 'n' , '<leader>fh' , ':Telescope find_files hidden=true previewer=false theme=get_dropdown<CR>' , options },
		-- バッファを検索
		{ 'n' , '<leader>fb' , ':Telescope buffers previewer=false theme=get_dropdown<CR>' , options },
		-- レジスタ一覧を検索
		{ 'n' , '<leader>fr' , ':Telescope registers<CR>' , options },
		-- ファイル内文字列を検索
		-- "$ sudo apt install ripgrep -y"で使用可能
		{ 'n' , '<leader>fg' , ':Telescope live_grep hidden=true previewer=true theme=get_dropdown<CR>' , options },

		-- toggleterm
		-- 下方,右側,フロートウィンドウのターミナルのトグル
		{ 'n' , '<leader>tt' , ':ToggleTerm size=20 direction=horizontal<CR>' , options },
		{ 'n' , '<leader>tv' , ':ToggleTerm size=60 direction=vertical<CR>' , options },
		{ 'n' , '<leader>tf' , ':ToggleTerm direction=float<CR>' , options },
		-- ノーマルモード時に現在カーソルのある行を,ビジュアルモード時に選択範囲をターミナルに送る
		{ 'n' , '<leader>ts' , ':ToggleTermSendCurrentLine<CR>' , options },
		{ 'v' , '<leader>ts' , ':ToggleTermSendVisualLines<CR>' , options },

		-- mini.files
		-- ファイラをトグル
		{ 'n', '<C-n>', minifiles_toggle, { noremap = true, silent = true } },

		-- copilot
		-- チャット用バッファをトグル
		{ {'n' , 'v'} , '<leader>cc' , ':CopilotChatToggle<CR>' , options },
		-- チャットをリセット
		{ {'n' , 'v'} , '<leader>cr' , ':CopilotChatReset<CR>' , options },
		-- 言語モデルを変更
		{ {'n' , 'v'} , '<leader>cm' , ':CopilotChatModels<CR>' , options },

	}

	-- テーブルの内容をループし代入
	for _, kmaps in pairs(kmaps) do

		vim_keymap(kmaps[1] , kmaps[2] , kmaps[3] , kmaps[4])

	end

end

