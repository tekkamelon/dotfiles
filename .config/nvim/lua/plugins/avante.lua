-- avante.lua
-- Neovim >= 0.11.0

if vim.g.vscode then return end

-- 環境変数からプロバイダ名を取得
local provider_name = vim.env.AVANTE_PROVIDER

-- 変数の値がなければエラー通知
if not provider_name then
	vim.notify("AVANTE_PROVIDER environment variable is not set", vim.log.levels.ERROR)
	return
else
	-- 起動時にプロバイダを通知
	vim.notify("provider: " .. provider_name, vim.log.levels.INFO)
end

-- カスタムプロンプトを読み込み
local shortcuts = require("plugins.avante_shortcuts")

require('avante').setup {

	-- デフォルトのプロバイダ
	provider = provider_name,
	---@alias Mode "agentic" | "legacy"
	---@type Mode
	mode = "agentic",

	-- CLIコーディングエージェント
	-- コマンドと引数を指定してプロバイダを定義
	--  avante起動前に`:lua require("avante.api").switch_provider("opencode")`などで切り替え可能
	acp_providers = {

		["opencode"] = {
			command = "opencode",
			args = { "acp" }
		},

		["qwen-code"] = {
			command = "qwen",
			args = { "--acp" },
		},

		["goose"] = {
			command = "goose",
			args = { "acp" },
			-- 環境変数からAPIキーを渡さないと動作しない
			env = {
				NVIDIA_API_KEY = vim.env.NVIDIA_API_KEY,
				OPENROUTER_API_KEY = vim.env.OPENROUTER_API_KEY,
				SAKURA_API_KEY = vim.env.SAKURA_API_KEY,
				CUSTOM_SAKURA_API_KEY = vim.env.SAKURA_API_KEY,
				-- MCPサーバー用APIキー
				BRAVE_API_KEY = vim.env.BRAVE_API_KEY,
			},
		},

		["cline"] = {
			command = "cline",
			args = { "--acp" },
		},

		["openhands"] = {
			command = "openhands",
			args = { "acp" },
		},

		["kilocode"] = {
			command = "kilocode",
			args = { "acp" },
		},

		["codex"] = {
			command = "npx",
			args = { "@zed-industries/codex-acp" },
		},

		["zeroclaw"] = {
			command = "zeroclaw",
			args = { "acp" },
		},

		["hermes"] = {
			command = "hermes",
			args = { "acp" },
		},

		["grok"] = {
			command = "grok",
			args = {
				"agent",
				"stdio",
			},
		},

		["pi"] = {
			command = "pi-acp",
			args = {},
		},

		["dsh"] = {
			command = "dsh",
			args = {
				"--profile",
				"acp"
			},
		},
	},

	-- 各種自動設定
	behaviour = {
		auto_suggestions = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		minimize_diff = true,
		auto_apply_diff_after_generation = false,
	},

	config = {
		-- 検索エンジン
		web_search_engine = {
			provider = "tavily",
			proxy = nil,
		}
	},

	windows = {
		wrap = true,
		width = 37,
		input = {
			prefix = "> ",
			height = 17,
		},
		ask = {
			start_insert = false,
			border = "rounded"
		},
	},

	suggestion = {
		debounce = 800,
	},

	selection = {
		enabled = false,
	},

	selector = {
		provider = "telescope",
	},

	shortcuts = shortcuts,
}

-- ACP の一部プロバイダは rawInput/rawOutput を Lua の userdata として返す。
-- v0.0.29 の履歴レンダラはこれらを table として直接参照するため、
-- 表示時だけ非 table の値を隠して履歴全体を描画できるようにする。
do
	local Render = require("avante.history.render")
	local function sanitize_message(message)
		if type(message) ~= "table" or type(message.acp_tool_call) ~= "table" then
			return message
		end

		local raw_input = message.acp_tool_call.rawInput
		local raw_output = message.acp_tool_call.rawOutput
		if (raw_input == nil or type(raw_input) == "table")
			and (raw_output == nil or type(raw_output) == "table") then
			return message
		end

		local sanitized = vim.tbl_extend("force", {}, message)
		sanitized.acp_tool_call = vim.tbl_extend("force", {}, message.acp_tool_call)
		if type(raw_input) ~= "table" then sanitized.acp_tool_call.rawInput = nil end
		if type(raw_output) ~= "table" then sanitized.acp_tool_call.rawOutput = nil end
		return sanitized
	end

	local message_to_lines = Render.message_to_lines
	Render.message_to_lines = function(message, messages, expanded)
		return message_to_lines(sanitize_message(message), messages, expanded)
	end

	local message_to_text = Render.message_to_text
	Render.message_to_text = function(message, messages)
		return message_to_text(sanitize_message(message), messages)
	end
end

-- ACPの設定項目の選択肢を組み立てる処理を修正する。
-- ・description を userdata で返すエージェント (pi等) があり、文字列の場合のみ連結する。
-- ・dsh等は ACP 仕様のグループ形式 (options = { { group, name, options = {...} }, ... })
--   を返すため、平坦な配列と同様に展開して1件ずつ選択できる様にする。
-- 上流の更新に追従できる様、実行時にソースへ最小差分を当てて preload する。
do
	local modname = "avante.acp_config_selector"
	local paths = vim.api.nvim_get_runtime_file("lua/avante/acp_config_selector.lua", false)
	local path = paths[1]
	if not path then return end
	local file = io.open(path, "r")
	if not file then return end
	local src = file:read("*a")
	file:close()
	local old = [[
        for _, val in ipairs(opt.options) do
          local prefix = val.value == opt.currentValue and "* " or "  "
          local label = prefix .. val.name
          if val.description then label = label .. " - " .. val.description end
          table.insert(display, label)
          table.insert(items, { config_id = opt.id, value = val.value })
        end]]
	local new = [[
        local function push_option(val, group_name)
          if type(val) ~= "table" then return end
          if type(val.options) == "table" then
            for _, child in ipairs(val.options) do
              push_option(child, val.name or group_name)
            end
            return
          end
          if val.value == nil then return end
          local prefix = val.value == opt.currentValue and "* " or "  "
          local name = type(val.name) == "string" and val.name or tostring(val.value)
          if type(group_name) == "string" and group_name ~= "" then
            name = group_name .. " / " .. name
          end
          local label = prefix .. name
          if type(val.description) == "string" and val.description ~= "" then
            label = label .. " - " .. val.description
          end
          table.insert(display, label)
          table.insert(items, { config_id = opt.id, value = val.value })
        end
        for _, val in ipairs(opt.options) do
          push_option(val, nil)
        end]]
	if not src:find(old, 1, true) then return end
	local patched = src:gsub(old:gsub("(%W)", "%%%1"), new, 1)
	local chunk, err = load(patched, "@" .. path)
	if not chunk then
		vim.notify("avante patch failed: " .. (err or ""), vim.log.levels.WARN)
		return
	end
	local ok, mod = pcall(chunk)
	if ok and mod then
		mod._patched_by_config = true
		package.loaded[modname] = mod
		package.preload[modname] = function() return mod end
	end
end
