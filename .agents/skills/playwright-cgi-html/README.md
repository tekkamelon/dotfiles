# playwright-cgi-html スキル

Playwright を使ってCGIアプリケーション・サーバーレンダリングHTMLをE2Eテストするためのエージェントスキルです。

---

## このスキルでできること

- **CGIスクリプト（sh/Python/Perl）** が返すHTMLページのテスト
- **フォームPOST → CGI → 結果ページ** の一連の流れのテスト
- **JavaScript による非同期コンテンツ** （fetch/XHR でCGIを呼ぶページ）のテスト
- **ナビゲーションリンク** の動作確認
- **スクリーンショット回帰テスト**
- **設定の保存・読み込み** など副作用のあるCGI操作のテスト

Book Manager のような構成（静的HTML + CGIバックエンド + 少量のJS）はもちろん、
他のCGIプロジェクトや通常のWebアプリにも転用できます。

---

## ファイル構成

```
playwright-cgi-html/
├── SKILL.md                  ← エージェント向け指示書（英語）
├── README.md                 ← このファイル
└── examples/
    ├── example_playwright.config.js  ← 設定ファイルのサンプル
    └── example_test.spec.js      ← テストファイルのサンプル
```

---

## クイックスタート

### 1. インストール

```bash
# プロジェクトルートで実行
npm init playwright@latest
# → tests/ ディレクトリと playwright.config.js が生成される
```

すでにNode.jsプロジェクトがある場合:

```bash
npm install -D @playwright/test
playwright install chromium
```

### 2. 設定ファイルを確認・調整

`playwright.config.js` の `baseURL` を自分のサーバーに合わせる:

```js
use: {
  baseURL: 'http://localhost',  // ← ここを変える
}
```

環境変数で上書きすることも可能:

```bash
BASE_URL=http://192.168.1.10:80 playwright test
```

### 3. テストを実行

```bash
# サーバーを起動してから実行
playwright test

# ブラウザを表示しながら（デバッグ用）
playwright test --headed

# 特定のファイルだけ
playwright test tests/add.spec.js

# HTMLレポートを表示
playwright show-report
```

---

## テストファイルの書き方

### 基本構造

```js
// @ts-check
const { test, expect } = require('@playwright/test');

test.describe('書籍追加ページ', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto('/html/add.html');
  });

  test('ISBNフォームが表示される', async ({ page }) => {
    await expect(page.locator('input#isbn')).toBeVisible();
  });

  test('ISBNを入力して送信するとCGI結果ページが表示される', async ({ page }) => {
    await page.fill('input#isbn', '9784873119076');
    await Promise.all([
      page.waitForNavigation(),
      page.click('input[type="submit"]'),
    ]);
    await expect(page.locator('.result')).toBeVisible();
  });

});
```

### CGIが返す非同期コンテンツを待つ

```js
// fetch() でCGIを呼ぶページ（list.htmlなど）
await page.goto('/html/list.html', { waitUntil: 'networkidle' });
await page.waitForSelector('table');
```

### セレクターの選び方（信頼性の高い順）

| 優先度 | 書き方 | 特徴 |
|--------|--------|------|
| 1 | `page.getByRole('button', { name: '実行' })` | ARIA役割 + テキスト。最も堅牢 |
| 2 | `page.getByLabel('ISBN')` | `<label>` との対応。フォームに最適 |
| 3 | `page.getByText('追加結果')` | 表示テキストで特定 |
| 4 | `page.locator('#isbn')` | ID指定。IDが意味を持つなら有効 |
| 5 | `page.locator('[name="isbn"]')` | 属性指定 |
| 6 | `page.locator('.result')` | クラス名（変わりやすいので注意） |

---

## よくあるトラブルと対処

| 症状 | 原因 | 対処 |
|------|------|------|
| `Timeout waiting for selector` | JSの非同期処理が終わっていない、CGIが遅い | `waitForSelector` のタイムアウトを延ばす |
| `net::ERR_CONNECTION_REFUSED` | サーバーが起動していない | テスト前にサーバーを起動する |
| CGIが404を返す | `mod_cgi` が有効でない、パスが違う | Apache設定と `ScriptAlias` を確認 |
| スクリーンショットがズレる | OS・フォントの違い | `maxDiffPixelRatio: 0.02` で許容範囲を設定 |
| `strict mode violation` | 同じセレクターが複数マッチ | `.first()` を付けるか、セレクターを絞る |

### 生のCGIレスポンスを確認したいとき

```js
const response = await page.request.post('/cgi-bin/add.cgi', {
  form: { isbn: '9784873119076', add_to_csv: 'yes' },
});
console.log(await response.text());
```

---

## Raspberry Pi / 低スペック環境での注意

CGIのレスポンスが遅くなる場合はタイムアウトを延ばす:

```js
// playwright.config.js
module.exports = defineConfig({
  timeout: 60_000,  // 60秒
  use: {
    actionTimeout: 15_000,
  },
});
```

---

## エージェントへの指示例

このスキルを持つエージェントに対して、以下のように依頼できます:

- 「`add.cgi` のフォーム送信をPlaywrightでテストして」
- 「`list.html` が非同期でテーブルを読み込む動作をE2Eテストで確認したい」
- 「ナビゲーションの全リンクが正しいページに遷移するか確認するテストを書いて」
- 「`settings.cgi` への設定保存が画面に反映されるかテストして」
- 「Playwrightのテストが `Timeout` で落ちている原因を調べて」

---

## 参考リンク

- [Playwright 公式ドキュメント](https://playwright.dev/docs/intro)
- [ロケーター（セレクター）ガイド](https://playwright.dev/docs/locators)
- [ベストプラクティス](https://playwright.dev/docs/best-practices)
- [ネットワークモック](https://playwright.dev/docs/network)
