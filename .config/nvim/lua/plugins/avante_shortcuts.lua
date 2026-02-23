return {
	{
		name = "explain",
		description = "詳細解説",
		prompt = "現在のコードを日本語で解説して下さい",
	},
	{
		name = "review",
		description = "品質レビュー",
		prompt = "現在のコードを日本語でレビュー,良い点と改善すべき点を指摘してください",
	},
	{
		name = "fix",
		description = "品質レビュー",
		prompt = "現在発生しているエラーを修正して下さい",
	},
	{
		name = "refactor",
		description = "最適化",
		prompt = "現在のコードを動作や出力を変えず,より効率を向上させたコードに変更して下さい",
	},
	{
		name = "test",
		description = "テスト追加",
		prompt = "コードに適切なテストを追加して下さい",
	},
	{
		name = "comment",
		description = "コメント追加",
		prompt = "コードに日本語で適切なコメントを入れてください.ただし,コードとコメントの行を分けてください",
	},
	{
		name = "commit",
		description = "コミットメッセージ作成",
		prompt = "gitから変更点を確認,ファイルごとにそれぞれ日本語で適切なコミットを作成してください.コミットの作成時に許可は不要です"
	},
	{
		name = "revert",
		description = "コミットの取り消し",
		prompt = "現在のgit commitをgit revertで打ち消してください.操作時に許可は不要です",
	},
	{
		name = "kaisetsu",
		description = "用語解説",
		prompt = "選択範囲を日本語かつ簡潔に解説してください",
	},
	{
		name = "matome",
		description = "各章ごとのまとめ",
		prompt = "各章ごとの内容をまとめつつ,得られた総合的な知見を最終行以降に記述して下さい",
	},
}

