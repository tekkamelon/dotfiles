-- avante_pi_history.lua

-- ACP の一部プロバイダは rawInput/rawOutput を Lua の userdata として返す。
-- v0.0.29 の履歴レンダラはこれらを table として直接参照するため、
-- 表示時だけ非 table の値を隠して履歴全体を描画できるようにする。

local M = {}

local function sanitize_value(value, seen)
	-- vim.json.decode は空オブジェクト `{}` を userdata (vim.empty_dict()) で返す.
	-- pi-acp は rawInput/rawOutput に `{}` を送るため, avante 側の
	-- `update.rawInput.description` 等の table アクセスで
	-- `attempt to index field 'rawInput' (a userdata value)` となる. 再帰的に table へ戻す.
	if type(value) == "userdata" then return {} end
	if type(value) ~= "table" then return value end
	seen = seen or {}
	if seen[value] then return seen[value] end
	local copy = value
	-- History.Message 等のメタテーブル付きは触らない (params/update の plain table のみ複製)
	if getmetatable(copy) == nil then
		copy = {}
		seen[value] = copy
		for k, v in pairs(value) do
			copy[k] = sanitize_value(v, seen)
		end
	else
		seen[value] = copy
	end
	return copy
end

function M.setup()
	-- ACP 受信直後に正規化: llm.lua の add_tool_call_message 到達前に userdata を潰す
	pcall(function()
		local ACPClient = require("avante.libs.acp_client")
		if ACPClient._pi_history_patched then return end
		ACPClient._pi_history_patched = true
		local handle_session_update = ACPClient._handle_session_update
		if handle_session_update then
			function ACPClient:_handle_session_update(params, ...)
				return handle_session_update(self, sanitize_value(params), ...)
			end
		end
		local handle_request_permission = ACPClient._handle_request_permission
		if handle_request_permission then
			function ACPClient:_handle_request_permission(message_id, params, ...)
				return handle_request_permission(self, message_id, sanitize_value(params), ...)
			end
		end
	end)

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

return M
