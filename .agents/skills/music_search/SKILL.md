---
name: music_search
description: >
  指示に応じて要望に合致するウェブラジオをインターネットから検索し各種シェルコマンドで指定されたホスト上のmpdで再生再生するためのスキル
  トリガーとなるワードは"mpc", "音楽を探す", "mpd", "webラジオ"及びそれに類するもの
---

# music_search

## Purpose

指示に応じてインターネット上のウェブラジオを検索し指定されたホスト上のmpdのキューに追加,再生する

## 前提条件

- `mpc` コマンドがインストールされていること
- `radio-browser-cli` コマンドがインストールされていること (同リポジトリ内に配置済み)
- MPDサーバが稼働していること

## 利用ツール

- `web_search` 系のツール : 曖昧な要望や特定のラジオ局名を調べるために使用
- `radio-browser-cli` : Radio-Browser.info APIを利用してURLを取得
- `mpc` : MPDのコマンドラインクライアント

## 検索ツールの使い分け

### web_search 系ツール

曖昧な感情やシーンに基づく要望に対して使用する。
具体例:
- 睡眠時にぴったりな音楽
- 朝に合う爽やかな音楽
- 集中したい時に聴く音楽

このような場合、まず web_search 系ツールでおすすめのラジオ局名やストリーミングURLを調査する。

### radio-browser-cli

具体的なジャンル、国名、タグが指定されている場合に使用する。
具体例:
- ジャズやlofiを流して
- 日本の音楽を流して
- クラシックのラジオを探して

また、web_search で特定のラジオ局名を取得した後、その局の URL を radio-browser-cli で取得することもある。

## radio-browser-cli の使い方

### ラジオ局の検索

```bash
radio-browser-cli search [オプション]
```

オプション:
- `--name NAME` : ラジオ局名で検索
- `--country COUNTRY` : 国名で検索 (例: Japan)
- `--tag TAG` : ジャンル/タグで検索 (例: jazz)
- `--language LANGUAGE` : 言語で検索 (例: japanese)
- `--limit LIMIT` : 結果の最大表示数 (デフォルト: 20)
- `--format {csv,tsv,urls,json,m3u}` : 出力形式 (デフォルト: csv)

### URLのみを取得する

`mpc add` に渡すためには `--format urls` を使用する

```bash
radio-browser-cli search --name "BBC" --format urls
```

### 国の一覧を確認する

```bash
radio-browser-cli countries
```

### タグの一覧を確認する

```bash
radio-browser-cli tags
```

## mpc の使い方

### ホストの指定

- 環境変数 `MPD_HOST` を設定するか、`--host` オプションを使用する
- ユーザー指定のホスト名があれば `mpc --host="ホスト名"` を使用する

```bash
# 環境変数で指定
export MPD_HOST=localhost

# コマンドオプションで指定
mpc --host="localhost"
```

### キューへの追加

```bash
mpc add "URL"
```

## ワークフロー

1. ユーザーからの要望を判断する
   - 曖昧な要望 (感情やシーン) -> web_search 系ツールで候補を調査
   - 具体的なジャンル/国/タグ -> radio-browser-cli で直接検索
2. ラジオ局名が分かっている場合 -> radio-browser-cli で URL を取得 (`--format urls`)
3. `mpc add` で取得した URL を mpd のキューに追加する
   - ホスト名が指定されている場合は `--host=` オプションを付与する
4. 必要に応じて `mpc play` で再生を開始する

### 実行例

```bash
# web_search で局名を調べた後、radio-browser-cli でURLを取得
url=$(radio-browser-cli search --name "BBC" --format urls | head -n 1)

# ローカルのMPDに追加
mpc add "${url}"

# リモートのMPDに追加する場合
mpc --host="remote-host" add "${url}"
```

## Scripts

シェルスクリプトは `scripts/` ディレクトリに配置されている。

### search_and_add.sh

検索ワードを指定してラジオ局を検索し、mpd のキューに追加する。

```bash
scripts/search_and_add.sh "検索ワード" [ホスト名]
```

- 第1引数: 検索ワード (必須)
- 第2引数: MPDホスト名 (オプション、デフォルト: localhost)

## Constitution

- NEVER: 既存のキューをクリアしてはならない (`mpc clear` を使用しない)
- `mpc add` のみを使用し、ユーザーの既存の再生キューを尊重すること
