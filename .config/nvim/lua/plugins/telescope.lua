if vim.g.vscode then return end

require("telescope").setup({
	defaults = {
		prompt_prefix = " 🔎 ",
		selection_caret = " ➤	 ",
	},
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

-- プロバイダー選択関数
-- avante.configからACPプロバイダーリストを取得し,Telescopeピッカーで選択
local function select_avante_provider(opts)
	opts = opts or {}

	-- avante.configをにロード
	local ok, Config = pcall(require, 'avante.config')
	if not ok then
		vim.notify('avante.configを読み込めませんでした', vim.log.levels.ERROR)
		return
	end

	-- ACPプロバイダーリストを取得
	local acp_providers = Config.acp_providers
	-- プロバイダー名のリストを取得
	local providers = vim.tbl_keys(acp_providers)

	-- アルファベット順にソート
	table.sort(providers)

	-- avante.apiをロード
	local api = require('avante.api')

	-- Telescopeピッカーを作成して表示
	pickers.new(opts, {
		-- プロンプトのタイトルを設定
		prompt_title = 'Select Avante Provider',
		-- プロバイダーのリストを検索対象に設定
		finder = finders.new_table({
			results = providers,
		}),
		-- 汎用ソーターを使用
		sorter = conf.generic_sorter(opts),
		-- キーマッピングを設定
		attach_mappings = function(prompt_bufnr)
			-- 選択時のアクションを定義
			actions.select_default:replace(function()
				-- 選択されたエントリを取得
				local selection = action_state.get_selected_entry()
				-- ピッカーを閉じる
				actions.close(prompt_bufnr)
				-- プロバイダー名を取得（余白を除去）
				local provider = vim.trim(selection[1])
				-- 選択されたプロバイダーに切り替え
				api.switch_provider(provider)
			end)
			return true
		end,
	}):find()
end

-- ユーザーコマンドとして登録
vim.api.nvim_create_user_command('TelescopeAvanteProvider', function()
	select_avante_provider()
end, {})
