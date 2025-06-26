-- copilotchat.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	require('CopilotChat').setup{

		-- デフォルトの言語モデルを変更
		model = "gpt-4o",

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

end

