-- minuet-ai.lua
-- neovim >= 0.10.0


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('minuet').setup{

		-- 仮想テキストの設定 
		virtualtext = {

			auto_trigger_ft = {},
			keymap = {

				next = '<C-f>',
				prev = '<C-F>',

			},

		},

		provider = 'openai_compatible',
		request_timeout = 2.5,

		-- APIリクエストの制限(ミリ秒)
		throttle = 1500,

		-- 遅延
		debounce = 600,

		provider_options = {

			openai_compatible = {

				api_key = 'OPENROUTER_API_KEY',

				end_point = 'https://openrouter.ai/api/v1/chat/completions',

				model = 'meta-llama/llama-4-maverick:free',

				name = 'Openrouter',

				optional = {

					max_tokens = 56,

					top_p = 0.9,

					-- プロバイダのソート順
					provider = {

						-- スループットを優先
						sort = 'throughput',

					},

				},

			},

		},

	}

	local minuet_vtext = require('minuet.virtualtext')

	-- キーマッピングの設定
	-- サジェストの受け入れ
	vim.keymap.set("i", "<Tab>", function()

		-- サジェストの表示状態
		local suggest = minuet_vtext.action.is_visible()

		-- サジェストを表示している場合
		if suggest then

			minuet_vtext.action.accept()

		else

			-- サジェストされていない場合はタブを入力
			-- キーコードをneovimが解釈可能な形式に変換
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)

		end

	end, { expr = true, silent = true })

	-- 行単位のサジェストの受け入れ
	vim.keymap.set("i", "<C-s>", minuet_vtext.action.accept_line)

	-- サジェストのキャンセル
	vim.keymap.set("i", "<C-q>", minuet_vtext.action.dismiss)

	vim.cmd('Minuet virtualtext enable')

end
