-- copilotchat.lua (統合版)

-- vscodeから起動していなければ真
if not vim.g.vscode then

	local chat = require("CopilotChat")
	chat.setup{

		-- デフォルトの言語モデルを変更
		model = "gpt-4.1",

		-- チャット用のバッファの設定
		window = {

			layout = 'horizontal',
			width = 0.5,
			height = 0.4,

		},

		system_prompt = "日本語かつ絵文字を使わずに読書家のメイド口調でお願いします。私に呼びかける際はご主人様と呼んでください",

		sticky = {

			'#buffer',

		},

	}

	-- MCP統合部分
	local mcp = require("mcphub")
	mcp.on({ "servers_updated", "tool_list_changed", "resource_list_changed" }, function()
		local hub = mcp.get_hub_instance()
		if not hub then
			return
		end

		local async = require("plenary.async")
		local call_tool = async.wrap(function(server, tool, input, callback)
			hub:call_tool(server, tool, input, {
				callback = function(res, err)
					callback(res, err)
				end,
			})
		end, 4)

		local access_resource = async.wrap(function(server, uri, callback)
			hub:access_resource(server, uri, {
				callback = function(res, err)
					callback(res, err)
				end,
			})
		end, 3)

		for name, tool in pairs(chat.config.functions) do
			if tool.id and tool.id:sub(1, 3) == "mcp" then
				chat.config.functions[name] = nil
			end
		end
		local resources = hub:get_resources()
		for _, resource in ipairs(resources) do
			local name = resource.name:lower():gsub(" ", "_"):gsub(":", "")
			chat.config.functions[name] = {
				id = "mcp:" .. resource.server_name .. ":" .. name,
				uri = resource.uri,
				description = type(resource.description) == "string" and resource.description or "",
				resolve = function()
					local res, err = access_resource(resource.server_name, resource.uri)
					if err then
						error(err)
					end

					res = res or {}
					local result = res.result or {}
					local content = result.contents or {}
					local out = {}

					for _, message in ipairs(content) do
						if message.text then
							table.insert(out, {
								uri = message.uri,
								data = message.text,
								mimetype = message.mimeType,
							})
						end
					end

					return out
				end,
			}
		end

		local tools = hub:get_tools()
		for _, tool in ipairs(tools) do
			chat.config.functions[tool.name] = {
				id = "mcp:" .. tool.server_name .. ":" .. tool.name,
				group = tool.server_name,
				description = tool.description,
				schema = tool.inputSchema,
				resolve = function(input)
					local res, err = call_tool(tool.server_name, tool.name, input)
					if err then
						error(err)
					end

					res = res or {}
					local result = res.result or {}
					local content = result.content or {}
					local out = {}

					for _, message in ipairs(content) do
						if message.type == "text" then
							table.insert(out, {
								data = message.text,
							})
						elseif message.type == "resource" and message.resource and message.resource.text then
							table.insert(out, {
								uri = message.resource.uri,
								data = message.resource.text,
								mimetype = message.resource.mimeType,
							})
						end
					end

					return out
				end,
			}
		end
	end)

end