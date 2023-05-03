-- default_plug.lua
-- 標準プラグインの読み込みの設定

-- "vim.g"をテーブルで設定
local options = {

	did_install_default_menus = 1,
	did_load_ftplugin = 1,
	did_load_filetypes = 1,
	loaded_2html_plugin = 1,
	loaded_gzip = 1,
	loaded_man = 1,
	loaded_matchit = 1,
	loaded_remote_plugins = 1,
	loaded_shada_plugin = 1,
	loaded_spellfile_plugin = 1,
	loaded_tarPlugin = 1,
	loaded_tutor_mode_plugin = 1,
	loaded_zipPlugin = 1,
	skip_loading_mswin = 1,
	loaded_rrhelper = 1,
	loaded_vimball = 1,
	loaded_vimballPlugin = 1,
	loaded_getscript = 1,
	loaded_getscriptPlugin = 1,
	loaded_netrw = 1,
	loaded_netrw = 1,
	loaded_netrwPlugin = 1,
	loaded_netrwSettings = 1,
	loaded_netrwFileHandlers = 1,

}

-- "options"内の左辺を"let",右辺を"toggle"にそれぞれ代入しループ
for let, toggle in pairs(options) do

  vim.g[let] = toggle

end
