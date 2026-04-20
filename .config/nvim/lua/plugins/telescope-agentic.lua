local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

local function select_agentic_provider(opts)
	opts = opts or {}

	local agentic_ok, Agentic = pcall(require, 'agentic')
	if not agentic_ok then
		vim.notify('agenticを読み込めませんでした', vim.log.levels.ERROR)
		return
	end

	local config = Agentic.config
	if not config or not config.acp_providers then
		vim.notify('acp_providersが設定されていません', vim.log.levels.ERROR)
		return
	end

	local acp_providers = config.acp_providers
	local providers = vim.tbl_keys(acp_providers)

	table.sort(providers)

	pickers.new(opts, {
		prompt_title = 'Select Agentic Provider',
		finder = finders.new_table({
			results = providers,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				local provider = vim.trim(selection[1])
				Agentic.switch_provider(provider)
			end)
			return true
		end,
	}):find()
end

vim.api.nvim_create_user_command('TelescopeAgenticProvider', function()
	select_agentic_provider()
end, {})