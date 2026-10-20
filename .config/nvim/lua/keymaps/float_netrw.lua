-- float_netrw.lua
-- 左上フロートウィンドウでnetrwを扱うモジュール

local M = {}

local augroup = vim.api.nvim_create_augroup('float_netrw', { clear = true })

local float_netrw_win = nil
local float_netrw_buf = nil
local return_win = nil

-- カーソル下のnetrwパスを取得する
-- ファイルならフルパス, ディレクトリならフルパス, 取得失敗時はnil
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

	-- フォールバック時の装飾記号を取り除く
	-- ディレクトリの末尾スラッシュはnormalizeで吸収する
	word = word:gsub('[@*]$', '')

	local curdir = vim.b.netrw_curdir or vim.fn.expand('%:p:h')
	if curdir == nil or curdir == '' then
		curdir = vim.fn.getcwd()
	end

	-- 絶対パスはそのまま, 相対パスはカレントディレクトリと結合する
	local full = word
	if word:sub(1, 1) ~= '/' and word:match('^%a:[/\\]') == nil then
		full = vim.fs.joinpath(curdir, word)
	end
	return vim.fs.normalize(full)
end

-- フロートウィンドウを閉じる
local function close_float()
	if float_netrw_win ~= nil and vim.api.nvim_win_is_valid(float_netrw_win) then
		vim.api.nvim_win_close(float_netrw_win, true)
	end
	float_netrw_win = nil
	float_netrw_buf = nil
end

-- 記憶した元ウィンドウへ戻る
local function restore_return_win()
	local win = return_win
	return_win = nil
	if win ~= nil and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_set_current_win(win)
		return true
	end
	return false
end

-- フロートを閉じて元のウィンドウに戻る
local function close_and_return()
	close_float()
	return restore_return_win()
end

-- netrwバッファでファイルを通常バッファで開く
local function open_in_return_win()
	local target = get_netrw_target()
	if target == nil then
		return
	end

	-- ディレクトリならフロート内で移動する
	if vim.fn.isdirectory(target) == 1 then
		vim.cmd.Explore({ args = { target } })
		return
	end

	-- ファイルならフロートを閉じて元のウィンドウで開く
	close_float()
	if not restore_return_win() then
		vim.notify('float_netrw: 元のウィンドウが見つかりません', vim.log.levels.WARN)
	end
	vim.cmd.edit({ args = { target } })
end

-- フロート内のnetrwバッファにキーマップを設定する
local function apply_netrw_mappings(buf)
	vim.keymap.set('n', '<CR>', open_in_return_win, {
		noremap = true,
		silent = true,
		buffer = buf,
		desc = 'netrw: 通常バッファで開く',
	})
	vim.keymap.set('n', '<Esc>', close_and_return, {
		noremap = true,
		silent = true,
		buffer = buf,
		desc = 'netrw: フロートを閉じる',
	})
end

-- フロートの大きさを計算する
local function calc_geometry()
	local width = math.floor(vim.o.columns * 0.25)
	local height = vim.o.lines - vim.o.cmdheight - 3

	width = math.max(width, 20)
	height = math.max(height, 10)

	-- 画面が狭い場合ははみ出さないように上限を設ける
	width = math.min(width, math.max(vim.o.columns - 2, 1))
	height = math.min(height, math.max(vim.o.lines - vim.o.cmdheight - 1, 1))

	return width, height
end

-- FileType netrwでフロート内ならマッピングを追従させる
vim.api.nvim_create_autocmd('FileType', {
	group = augroup,
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

-- 画面サイズの変更にフロートを追従させる
vim.api.nvim_create_autocmd('VimResized', {
	group = augroup,
	callback = function()
		if float_netrw_win == nil or not vim.api.nvim_win_is_valid(float_netrw_win) then
			return
		end
		local width, height = calc_geometry()
		vim.api.nvim_win_set_config(float_netrw_win, {
			width = width,
			height = height,
		})
	end,
})

-- 左上フロートnetrwをトグルする
function M.toggle()
	-- 既に開いていれば閉じて元のウィンドウに戻る
	if float_netrw_win ~= nil and vim.api.nvim_win_is_valid(float_netrw_win) then
		close_and_return()
		return
	end

	-- 開く前に元のウィンドウを記憶する
	return_win = vim.api.nvim_get_current_win()

	-- 現在編集中ファイルの親ディレクトリを開く
	local parent = vim.fn.expand('%:p:h')
	if parent == '' then
		parent = vim.fn.getcwd()
	end

	-- Exploreで置き換わる前提の一時バッファ
	float_netrw_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[float_netrw_buf].bufhidden = 'wipe'

	local width, height = calc_geometry()

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
	vim.cmd.Explore({ args = { parent } })
	-- Exploreでバッファが置き換わるため追従する
	float_netrw_buf = vim.api.nvim_get_current_buf()
	apply_netrw_mappings(float_netrw_buf)

	vim.api.nvim_create_autocmd('WinClosed', {
		group = augroup,
		pattern = tostring(float_netrw_win),
		once = true,
		callback = function()
			float_netrw_win = nil
			float_netrw_buf = nil
		end,
	})
end

return M
