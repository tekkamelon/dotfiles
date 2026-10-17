-- avante_pi_history.lua

-- ACP の一部プロバイダは rawInput/rawOutput を Lua の userdata として返す。
-- v0.0.29 の履歴レンダラはこれらを table として直接参照するため、
-- 表示時だけ非 table の値を隠して履歴全体を描画できるようにする。

local M = {}

function M.setup()
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
