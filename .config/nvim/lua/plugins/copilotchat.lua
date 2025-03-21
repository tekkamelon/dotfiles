-- copilotchat.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('CopilotChat').setup{

		-- デフォルトの言語モデルを変更
		model = "claude-3.5-sonnet",

		-- チャット用のバッファの設定
		window = {

			layout = 'horizontal',
			width = 0.5,
			height = 0.4,

		},

	}

end
