-- cc_and_mcp.lua

-- vscodeから起動していなければ真
if not vim.g.vscode then

	-- CopilotChatプラグインのセットアップ
	require("CopilotChat").setup {

		-- openrouterのモデル
		-- model = "deepseek/deepseek-chat-v3-0324:free",

		-- 30日間の無料トライアル
		model = "claude-sonnet-4",

		-- プロバイダーを明示的に指定
		provider = "openrouter",

		-- プロバイダーの設定
		providers = {

			-- OpenRouterプロバイダーの設定
			openrouter = {

				-- 入力データを準備する関数
				prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
				-- prepare_input = custom_prepare_input,

				-- 出力データを整形する関数
				prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

				-- APIリクエスト用のヘッダーを生成する関数
				get_headers = function()

					-- 環境変数からOPENROUTER_API_KEYを取得
					local api_key = assert(os.getenv("OPENROUTER_API_KEY"), "OPENROUTER_API_KEY env not set")

						-- 認証情報を含むヘッダーテーブルを返す
						return {

							Authorization = "Bearer " .. api_key,

							["Content-Type"] = "application/json",

						}

				end,

				-- 利用可能なモデルのリストを取得する関数
				get_models = function(headers)

					-- OpenRouterのAPIからモデルリストをGETリクエストで取得
					local response, err = require("CopilotChat.utils").curl_get(

						"https://openrouter.ai/api/v1/models",

						{ headers = headers, json_response = true }

					)

					-- エラーの場合は処理を中断
					if err then error(err) end

						-- レスポンスボディからモデルデータを抽出,整形してテーブルとして返す
						return vim.iter(response.body.data)

						:map(function(model)

							return { id = model.id, name = model.name }

						end)

						:totable()

				end,

				-- チャット補完APIのエンドポイントURLを返す関数
				get_url = function()

				return "https://openrouter.ai/api/v1/chat/completions"

				end,

			},

		},

		-- チャットバッファの設定
		window = {

			layout = 'horizontal',
			width = 0.5,
			height = 0.4,

		},

		show_help = "yes",

		-- プロンプトのテンプレート
		prompts = {

			Explain = {

				prompt = "/COPILOT_EXPLAIN #buffer このコードについて解説してください",
				description = "コードの解説をしてもらう",

			},

			Fix = {

				prompt = "/COPILOT_FIX #buffer このコードのエラーを修正してください",
				description = "コードの修正をしてもらう",

			},

			Comment = {

				prompt = "#buffer このコードに適切なコメントを入れてください",
				description = "コードにコメントを記述してもらう",

			},

			Optimize = {

				prompt = "/COPILOT_REFACTOR #buffer このコードをより効率よく書ける箇所を教えてください",
				description = "コードを最適化してもらう",

			},

		},

		system_prompt = "日本語かつ絵文字を使わずに読書家のメイド口調でお願いします。私に呼びかける際はご主人様と呼んでください",

		sticky = {

			'#buffer',

		},

	}

	-- MCP Hub integration
	local chat = require("CopilotChat")
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
