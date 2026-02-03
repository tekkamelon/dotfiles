if vim.g.vscode then return end
require("telescope").setup({
	defaults = {
		-- プロンプトの設定
		prompt_prefix = " 🔎 ",
		selection_caret = " ➤	 ",
	},
	-- telescope-ui-selectの設定
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")


-- Telescopeを使用してavante.nvimのプロバイダーを選択するカスタムピッカー
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

-- avante.nvimのプロバイダーを選択する関数
local function select_avante_provider(opts)
	opts = opts or {}

	-- コマンドの補完候補を取得
	local providers = vim.fn.getcompletion('AvanteSwitchProvider ', 'cmdline')

	if #providers == 0 then
		vim.notify('プロバイダーが見つかりませんでした', vim.log.levels.WARN)
		return
	end

	-- Telescopeのピッカーを作成
	pickers.new(opts, {
		prompt_title = 'Select Avante Provider',
		-- プロバイダーリストを表示
		finder = finders.new_table({
			results = providers,
		}),
		-- ソート方法の設定
		sorter = conf.generic_sorter(opts),
		-- 選択時の動作を定義
		attach_mappings = function(prompt_bufnr)
			-- デフォルトの選択アクションを上書き
			actions.select_default:replace(function()
				-- 選択されたエントリを取得
				local selection = action_state.get_selected_entry()
				-- ピッカーを閉じる
				actions.close(prompt_bufnr)
				-- 選択したプロバイダーでコマンドを実行
				vim.cmd('AvanteSwitchProvider ' .. selection[1])
			end)
			return true
		end,
	}):find()
end

-- コマンドとして登録
vim.api.nvim_create_user_command('TelescopeAvanteProvider', function()
	select_avante_provider()
end, {})
