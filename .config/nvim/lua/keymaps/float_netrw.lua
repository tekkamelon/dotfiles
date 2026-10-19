-- float_netrw.lua
-- 左上フロートウィンドウでnetrwを扱うモジュール

local M = {}

local float_netrw_win = nil
local float_netrw_buf = nil
local return_win = nil

-- カーソル下のnetrwパスを取得する
-- ファイルならフルパス, ディレクトリならフルパス + is_dir, 取得失敗時はnil
local function get_netrw_target()
	local word = nil
	local ok, res = pcall(vim.fn['netrw#Call'], 'NetrwGetWord')
	if ok and res ~= nil and res ~= '' then
		word = res
	else
		word = vim.fn.expand('<cfile>')
	end
	if word == nil or word == '' then
		return nil
	end

	local curdir = vim.b.netrw_curdir or vim.fn.expand('%:p:h')
	local full = curdir .. '/' .. word
	-- netrwの表示名の装飾(@, /, *等)を取り除く
	full = full:gsub('[%*/=@|]+$', '')
	return full
end

-- netrwバッファでファイルを通常バッファで開く
local function open_in_return_win()
	local target = get_netrw_target()
	if target == nil then
		return
	end

	-- ディレクトリならフロート内で移動する
	if vim.fn.isdirectory(target) == 1 then
		vim.cmd('Explore ' .. vim.fn.fnameescape(target))
		return
	end

	-- ファイルならフロートを閉じて元のウィンドウで開く
	local win = return_win
	local buf_valid_win = win ~= nil and vim.api.nvim_win_is_valid(win)
	if float_netrw_win ~= nil and vim.api.nvim_win_is_valid(float_netrw_win) then
		vim.api.nvim_win_close(float_netrw_win, true)
	end
	float_netrw_win = nil
	float_netrw_buf = nil

	if buf_valid_win then
		vim.api.nvim_set_current_win(win)
	end
	vim.cmd('edit ' .. vim.fn.fnameescape(target))
end

-- フロート内のnetrwバッファにキーマップを設定する
local function apply_netrw_mappings(buf)
	vim.keymap.set('n', '<CR>', open_in_return_win, {
		noremap = true,
		silent = true,
		buffer = buf,
		desc = 'netrw: 通常バッファで開く',
	})
end

-- FileType netrwでフロート内ならマッピングを追従させる
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'netrw',
	callback = function(args)
		if float_netrw_win ~= nil
			and vim.api.nvim_win_is_valid(float_netrw_win)
			and vim.api.nvim_win_get_buf(float_netrw_win) == args.buf
		then
			apply_netrw_mappings(args.buf)
		end
	end,
})

-- 左上フロートnetrwをトグルする
M.toggle = function()
	-- 既に開いていれば閉じて元のウィンドウに戻る
	if float_netrw_win ~= nil and vim.api.nvim_win_is_valid(float_netrw_win) then
		vim.api.nvim_win_close(float_netrw_win, true)
		float_netrw_win = nil
		float_netrw_buf = nil
		if return_win ~= nil and vim.api.nvim_win_is_valid(return_win) then
			vim.api.nvim_set_current_win(return_win)
		end
		return
	end

	-- 開く前に元のウィンドウを記憶する
	return_win = vim.api.nvim_get_current_win()

	-- 現在編集中ファイルの親ディレクトリを開く
	local parent = vim.fn.expand('%:p:h')
	if parent == nil or parent == '' then
		parent = vim.fn.getcwd()
	end

	if float_netrw_buf == nil or not vim.api.nvim_buf_is_valid(float_netrw_buf) then
		float_netrw_buf = vim.api.nvim_create_buf(false, false)
	end

	local width = math.floor(vim.o.columns * 0.25)
	local height = vim.o.lines - 4
	if width < 20 then
		width = 20
	end
	if height < 10 then
		height = 10
	end

	float_netrw_win = vim.api.nvim_open_win(float_netrw_buf, true, {
		relative = 'editor',
		row = 1,
		col = 1,
		width = width,
		height = height,
		style = 'minimal',
		border = 'single',
		title = ' netrw ',
	})

	-- 親ディレクトリをフロート内で開く
	vim.cmd('Explore ' .. vim.fn.fnameescape(parent))
	-- Exploreでバッファが置き換わるため追従する
	float_netrw_buf = vim.api.nvim_get_current_buf()
	apply_netrw_mappings(float_netrw_buf)

	vim.api.nvim_create_autocmd('WinClosed', {
		pattern = tostring(float_netrw_win),
		callback = function()
			float_netrw_win = nil
		end,
		once = true,
	})
end

return M
