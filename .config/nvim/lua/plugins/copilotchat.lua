-- copilotchat.lua


-- vscodeから起動していなければ真
if not vim.g.vscode then

	-- 環境変数からユーザー名を取得,なければ"User"
	local username = os.getenv("USER") or "User"
	local my_sys_prompt = "日本語かつ絵文字を使わずに読書家のメイド口調でお願いします。私に呼びかける際はご主人様と呼んでください"

	-- CopilotChatプラグインのセットアップ
	require("CopilotChat").setup{

		headers = {

			-- ユーザー名の表示
			user = '## ' .. username .. ' ',

			-- アシスタント名の表示
			assistant = '## assistant '

		},

		-- デフォルトの言語
		language = 'Japanese',

		auto_fold = false,

		-- openrouterのモデル
		model = "x-ai/grok-4-fast:free",

		-- チャットバッファの設定
		window = {

			layout = 'horizontal',
			width = 0.5,
			height = 0.4,

		},

		show_help = true,

		-- システムプロンプト
		system_prompt = my_sys_prompt,

		-- プロンプトのテンプレート
		prompts = {

			Explain = {

				prompt = "/COPILOT_EXPLAIN #buffer コードを日本語で解説してください",
				description = "詳細解説",
				system_prompt = my_sys_prompt,

			},

			Review = {

				prompt = "/COPILOT_REVIEW #buffer コードを日本語でレビューし,改善したコードを提供してください",
				description = "品質レビュー",
				system_prompt = my_sys_prompt,

			},

			Fix = {

				prompt = "/COPILOT_FIX #buffer エラーを修正したコードを提供してください",
				description = "エラー修正",
				system_prompt = my_sys_prompt,

			},

			Optimize = {

				prompt = "/COPILOT_REFACTOR #buffer より効率を向上させたコードを提供してください",
				description = "最適化",
				system_prompt = my_sys_prompt,

			},

			Tests = {

				prompt = "#buffer コードに適切なテストを追加してください",
				description = "テスト追加",
				system_prompt = my_sys_prompt,

			},

			Comment = {

				prompt = "#buffer コードに日本語で適切なコメントを入れてください",
				description = "コメント追加",
				system_prompt = my_sys_prompt,


			},

		},

		sticky = {

			'#buffer',

		},

	}

	-- -- openrouterプロバイダの設定
	require('plugins.cc_provider.openrouter')

	-- LM Studioプロバイダの設定
	require('plugins.cc_provider.lmstudio')

end

