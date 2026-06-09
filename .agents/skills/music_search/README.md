# music_search

インターネットのウェブラジオ局を検索し、MPD (Music Player Daemon) で再生するためのスキルです。

## 概要

このスキルは、インターネットからウェブラジオ局を検索し、指定したホストのMPDキューに追加することを可能にします。`radio-browser-cli` を通じて Radio-Browser.info API を利用し、`mpc` コマンドラインクライアントでMPDを制御します。

## 機能

- 名前、国、ジャンル、言語でウェブラジオ局を検索します。
- MPD互換の直接ストリーミングURLを取得します。
- 既存のエントリを消去せずに局をMPDキューに追加します。
- `--host` オプションによるリモートMPDホストのサポート。
- 迅速な検索とキュー操作のためのヘルパースクリプト (`search_and_add.sh`) 。

## 前提条件

- [mpc](https://www.musicpd.org/clients/mpc/): MPDコマンドラインクライアント。
- [radio-browser-cli](../radio-browser-cli/radio-browser-cli): Radio-Browser.info API クライアント (このリポジトリに含まれています)。
- 実行中の [MPD](https://www.musicpd.org/) サーバー。

## クイックスタート

### 1. 局を検索する

```bash
# 名前で検索しURLを取得する
radio-browser-cli search --name "BBC" --format urls

# 国とジャンルで検索する
radio-browser-cli search --country "Japan" --tag "jazz" --format urls
```

### 2. MPDキューに追加する

```bash
# ローカルのMPDに追加する
mpc add "https://example.com/stream"

# リモートのMPDに追加する
mpc --host="remote-host" add "https://example.com/stream"
```

### 3. ヘルパースクリプトを使用する

```bash
# 局を検索し、最初の結果をキューに追加する
scripts/search_and_add.sh "BBC"

# リモートホストを指定する
scripts/search_and_add.sh "NHK" "192.168.1.100"
```

## ツール選択ガイド

| ユーザーのリクエスト | 推奨ツール |
|---|---|
| 漠然としている (例: "睡眠用音楽", "朝の目覚め") | `web_search` システムツール / ブラウザ |
| 特定のジャンル/国/タグ (例: "ジャズ", "日本") | `radio-browser-cli` |
| 既に局名を知っている | `radio-browser-cli` |

## 利用可能なコマンド

### radio-browser-cli

| コマンド | 説明 |
|---|---|
| `search` | 名前、国、タグ、言語で局を検索する。 |
| `countries` | 利用可能な国の一覧を表示する。 |
| `tags` | 利用可能なタグ/ジャンルの一覧を表示する。 |

詳細なオプションはツールの組み込みヘルプを参照してください:

```bash
radio-browser-cli --help
```

### mpc

| コマンド | 説明 |
|---|---|
| `add <url>` | URLをキューに追加する。 |
| `play` | 再生を開始する。 |
| `--host=<host>` | リモートMPDホストを指定する。 |

## 重要なルール

- **既存のキューを決して消去しないでください。** このスキルは新しい局を追加する (`mpc add`) のみであり、ユーザーの現在のプレイリストを尊重します。
- MPDに追加する前に、URLが正常に取得できたか必ず確認してください。

## プロジェクト構成

```
music_search/
├── SKILL.md              # エージェント用インストラクション (英語)
├── README.md             # 人間が読むためのドキュメント (このファイル)
└── scripts/
    └── search_and_add.sh # 検索とキュー操作用のヘルパースクリプト
```
