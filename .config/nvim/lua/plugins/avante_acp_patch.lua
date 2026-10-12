-- ACPの設定項目の選択肢を組み立てる処理を修正する。
-- ・description を userdata で返すエージェント (pi等) があり、文字列の場合のみ連結する。
-- ・dsh等は ACP 仕様のグループ形式 (options = { { group, name, options = {...} }, ... })
--   を返すため、平坦な配列と同様に展開して1件ずつ選択できる様にする。
-- 上流の更新に追従できる様、実行時にソースへ最小差分を当てて preload する。
return (function()
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
end)()
