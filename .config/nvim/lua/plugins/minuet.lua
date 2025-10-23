-- minuet-ai.lua
-- neovim >= 0.10.0

-- LLMの温度
local temperature_param = 0.1


-- vscodeから起動していなければ真
if vim.g.vscode then return end

require('minuet').setup {

	-- 仮想テキストの設定
	virtualtext = {

		-- 補完を自動起動するファイルタイプ
		auto_trigger_ft = {
			'bash',
			'awk',
			'lua',
			'python',
			'vim',
			'conf'
		},

		-- 除外するファイルタイプ
		auto_trigger_ignore_ft = {
			'markdown',
			'gitcommit',
			'Avante',
			'AvanteInput',
			'AvantePromptInput',
			'AvanteSelectedFiles',
			'AvanteSelectedCode',
			'TelescopePrompt'
		},

		-- キーマップ
		keymap = {
			accept_line = '<C-s>',
			accept_n_lines = '<C-e>',
			next = '<C-f>',
			prev = '<C-F>',
			dismiss = '<C-q>',
		},

	},

	-- groqに設定
	provider = 'openai_compatible',
	request_timeout = 2.5,

	-- APIリクエストの制限(ミリ秒)
	throttle = 1500,
	-- 遅延
	debounce = 600,

	show_on_completion_menu = true,

	-- プロバイダの設定
	provider_options = {

		-- openrouter
		openai_fim_compatible = {
			api_key = 'OPENROUTER_API_KEY',
			end_point = 'https://openrouter.ai/api/v1/completions',
			-- モデルを指定
			model = 'z-ai/glm-4.5-air:free',
			name = 'OpenRouter',
			stream = false,
			optional = {
				-- 温度
				temperature = temperature_param,
				-- プロバイダのソート順
				provider = {
					-- スループットを優先
					sort = 'throughput',
				},
			},
		},

		-- Groq
		openai_compatible = {
			api_key = 'GROQ_API_KEY',
			end_point = 'https://api.groq.com/openai/v1/chat/completions',
			model = 'moonshotai/kimi-k2-instruct-0905',
			name = 'Groq', stream = true,
			optional = {
				temperature = temperature_param,
			},
		},

		-- gemini
		gemini = {
			api_key = 'GEMINI_API_KEY',
			model = 'gemini-2.0-flash',
			name = 'Gemini',
			stream = true,
			end_point = 'https://generativelanguage.googleapis.com/v1beta/models',
			optional = {
				temperature = temperature_param,
			},
		},

	},

}

-- キーマップの処理
local minuet_vtext = require('minuet.virtualtext')

-- タブキーをサジェストの受け入れに設定
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


-- 除外するファイルタイプの処理
local ignore_ft = {
	'markdown',
	'gitcommit',
	'Avante',
	'AvanteInput',
	'AvantePromptInput',
	'AvanteSelectedFiles',
	'AvanteSelectedCode',
	'TelescopePrompt'
}

-- 起動時のバッファ
if vim.bo.filetype ~= "" and not vim.tbl_contains(ignore_ft, vim.bo.filetype) then
	vim.cmd("Minuet virtualtext enable")
end

-- 切替時のバッファ
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if not vim.tbl_contains(ignore_ft, vim.bo.filetype) then
			vim.cmd("Minuet virtualtext enable")
		end
	end,
})
