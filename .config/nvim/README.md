# neovim 設定

Neovim 0.12 以降を対象とした個人用の設定。プラグイン管理は標準機能の `vim.pack`、遅延読み込みは `lz.n` に任せる構成で、2026-11 の `refactor(nvim)` で lazy.nvim から移行した。

## 動作要件

- Neovim 0.12.0 以上
    - `init.lua` のヘッダには `neovim >= 0.9.0` とあるが、`lua/plugins.lua` が `vim.pack` を前提とするため 0.12 以上が必要 (検証環境は 0.12.6)
- tree-sitter CLI 0.26.1 以上と C コンパイラ
    - `nvim-treesitter` の main ブランチがパーサをビルドするため
    - 導入手順 (apt 版は 0.22.6 と古いため GitHub のバイナリを使う)

```sh
curl -sL https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.13/tree-sitter-linux-x64.gz \
    | gzip -dc > ~/.local/bin/tree-sitter && chmod +x ~/.local/bin/tree-sitter
```

- ripgrep
    - `<leader>fg` (`:Telescope live_grep`) で使用
- copilot-language-server
    - `npm install --global @github/copilot-language-server`
    - `vim.g.copilot_language_server_path` で明示指定も可能
- 任意: mason で導入する LSP サーバ、avante から呼ぶ ACP エージェント (後述)

## ディレクトリ構成

```text
.
├── init.lua                       起動時に読み込まれるメイン設定
├── init.vim                       旧設定 (現在は未使用)
├── light_init.lua                 プラグイン無しで起動する軽量設定
├── light_init.vim                 旧軽量設定 (現在は未使用)
├── .luarc.json                    lua_ls 用 (vim をグローバルとして扱う)
├── nvim-pack-lock.json            vim.pack のロックファイル
├── lazy-lock.json                 lazy.nvim 時代のロックファイル (未使用)
├── after/plugin/
│   ├── after_set.lua              プラグイン読み込み後のハイライト上書き
│   └── after_set.vim              旧設定 (現在は未使用)
└── lua/
    ├── plugins.lua                プラグインの導入と遅延読み込みの定義
    ├── plugins_old.lua            lazy.nvim 時代の定義 (未使用)
    ├── features/float_netrw.lua   左上フロート netrw の実装
    ├── keymaps/general.lua        プラグインに依存しないキーマップ
    ├── keymaps/plugins.lua        プラグイン用キーマップ
    ├── pop-os_plug.lua            jetpack 時代の設定 (未使用)
    ├── vscode-neovim_*.lua        旧 vscode-neovim 用設定 (未使用)
    └── plugins/
        ├── avante.lua / avante_shortcuts.lua
        ├── avante_acp_patch.lua / avante_pi_history.lua
        ├── blink-cmp.lua / copilot.lua
        ├── mason-lsp.lua / treesitter.lua / noice.lua
        ├── telescope.lua / hlchunk.lua / img-clip.lua
        ├── render-markdown.lua
        └── (未使用の旧設定は「未使用・レガシー」を参照)
```

## 起動の流れ

1. `init.lua`
    - `vim.loader.enable()` でモジュールを遅延ロード
    - 不要な標準プラグインを `vim.g.loaded_*` で無効化 (netrw 自体は `float_netrw` で使うため有効のまま)
    - オプションと autocmd をテーブルで一括適用, `mapleader` は Space
    - hostname に応じて colorscheme を選択
    - 最後に `require('plugins')`
2. `lua/plugins.lua`
    - `lz.n` を最初に `vim.pack.add` (init.lua 読み込み中は runtimepath 追加のみ)
    - setup 不要な依存プラグインを `vim.pack.add`
    - `PackChanged` で avante.nvim のビルドフックを登録
    - 本体プラグインは `load = function() end` でインストールのみ行う
    - `lz.n.load()` に遅延条件 (event / cmd / ft / keys) と `before` / `after` フックを定義
3. `UIEnter` (once) で `keymaps.general` と `keymaps.plugins` を読み込み
4. `after/plugin/after_set.lua` がプラグイン読み込み後に走り、ハイライトや treesitter の挙動を上書き

## プラグイン管理

### vim.pack

`vim.pack` は Neovim 0.12 で追加された標準のパッケージ管理。ユーザーコマンドは提供されず、Lua API のみ。

| 操作 | コマンド |
| --- | --- |
| 追加 | `:lua vim.pack.add({ { src = "https://github.com/owner/repo" } })` |
| 更新 | `:lua vim.pack.update()` (差分確認用のバッファが開くので、適用は `:write`、破棄は `:quit`) |
| 一覧取得 | `:lua vim.pack.get()` |
| 削除 | `:lua vim.pack.del({ "name" })` |

- ロックファイル `nvim-pack-lock.json` は `stdpath('config')`、つまり `~/.config/nvim/` に書かれる
- リポジトリ内の `nvim-pack-lock.json` は lz.n 導入前のスナップショットで、実環境の内容と一致していない。配備後に `diff` で差分を確認し、必要なら実環境側の内容で更新する
- リビジョン固定をしているもの
    - `noice.nvim`, `avante.nvim` (v0.0.29), `gitsigns.nvim`, `mason-lspconfig.nvim` は導入済みコミットを固定
    - `hop.nvim`, `blink.cmp` はバージョン範囲で指定

### lz.n

| フィールド | 意味 |
| --- | --- |
| `event` / `cmd` / `ft` / `keys` | 遅延読み込みのトリガ |
| `before` | 依存プラグインの先行読み込み (`load_deps` が `lz.n.trigger_load` を呼ぶ) |
| `after` | 従来の `config` / `opts` に相当するセットアップ処理 |
| `lazy = true` | トリガを持たず、`before` からの明示読み込みのみ |

- `before` フックは `vim.g.vscode` が真の場合に何もしない。VSCode 拡張から起動したときはプラグインを読み込まない方針
- 各 `after` でも VSCode 起動時は早期 return する

### avante.nvim のビルド

`PackChanged` autocmd で install / update を検知し、プラグインディレクトリで `make` を実行する。`build.sh` は旧リポジトリ名 (`yetone/avante.nvim`) を参照しており GitHub API のリダイレクトを追えないため、実行前に `avante-corp` へ置換し、完了後に `git checkout` で元へ戻す。

## プラグイン一覧

| プラグイン | 読み込みトリガ | 設定 |
| --- | --- | --- |
| `lz.n` | 起動時 (runtimepath のみ) | `lua/plugins.lua` |
| `plenary.nvim`, `nui.nvim`, `telescope-ui-select.nvim`, `friendly-snippets`, `blink-cmp-avante` | 依存のみ | なし |
| `vim-partedit` | `ModeChanged *:[vV]` | なし |
| `vim-edgemotion` | `BufReadPost`, `BufNewFile` | `lua/keymaps/plugins.lua` |
| `nvim-lspconfig` | `BufReadPost`, `BufNewFile`, `InsertEnter` | `lua/plugins/copilot.lua` を連鎖読み込み |
| `nvim-treesitter` (main) | `DeferredUIEnter` | `lua/plugins/treesitter.lua` |
| `mason.nvim` | `:Mason` | `lua/plugins.lua` 内で `setup({})` |
| `toggleterm.nvim` | `:ToggleTerm*` | `lua/plugins.lua` 内で `setup({})` |
| `noice.nvim` | `DeferredUIEnter` | `lua/plugins/noice.lua` |
| `telescope.nvim` | `:Telescope*` | `lua/plugins/telescope.lua` |
| `eyeliner.nvim` | キー押下 (`h j k l f w b e ge`) | `lua/plugins.lua` 内で `setup` |
| `img-clip.nvim` | `:PasteImage` | `lua/plugins/img-clip.lua` |
| `avante.nvim` | `ModeChanged *:[cvV]`, `:Avante*` | `lua/plugins/avante.lua` |
| `hlchunk.nvim` | `BufReadPost`, `BufNewFile` | `lua/plugins/hlchunk.lua` |
| `render-markdown.nvim` | ft `markdown`, `vimwiki`, `Avante` | `lua/plugins/render-markdown.lua` |
| `gitsigns.nvim` | `BufReadPost`, `BufNewFile` | `lua/plugins.lua` 内で `setup` |
| `hop.nvim` | `:Hop*` | `lua/plugins.lua` 内で `setup` |
| `nvim-colorizer.lua` | `:Colorizer*` | なし |
| `mini.pairs` | `InsertEnter` | `lua/plugins.lua` 内で `setup` |
| `mini.icons` | `before` からの明示読み込み | `lua/plugins.lua` 内で `setup` |
| `blink.cmp` | `InsertEnter` | `lua/plugins/blink-cmp.lua` |
| `mini.statusline` | `DeferredUIEnter` | `lua/plugins.lua` 内で `setup` |
| `mini.tabline` | `DeferredUIEnter` | `lua/plugins.lua` 内で `setup` |
| `mini.surround` | `ModeChanged *:[vV]` | `lua/plugins.lua` 内で `setup` |
| `mason-lspconfig.nvim` | `BufReadPost`, `BufNewFile` | `lua/plugins/mason-lsp.lua` |

### avante.nvim

- 既定プロバイダは環境変数 `AVANTE_PROVIDER` で決まる。未設定の場合はエラー通知のみで、avante の設定をスキップする
- プロバイダは API 経由のものに加え、ACP で CLI エージェントを呼べる

| 名前 | コマンド | 備考 |
| --- | --- | --- |
| `opencode` | `opencode acp` | |
| `qwen-code` | `qwen --acp` | |
| `goose` | `goose acp` | 環境変数の API キーを明示的に渡す |
| `cline` | `cline --acp` | |
| `openhands` | `openhands acp` | |
| `kilocode` | `kilocode acp` | |
| `codex` | `npx @zed-industries/codex-acp` | |
| `zeroclaw` | `zeroclaw acp` | |
| `hermes` | `hermes acp` | |
| `grok` | `grok agent stdio` | |
| `pi` | `pi-acp` | 事前に pi 側で `/login` が必要 (`~/.pi/agent/auth.json`) |
| `dsh` | `dsh --profile acp` | `.dsh/profiles/acp/cordis.patch.yml` に `- id: acp` が必要 |

- `mode = "agentic"`, web 検索は tavily, セレクタは telescope, diff の自動適用は無効
- `lua/plugins/avante_shortcuts.lua` が定型プロンプトを定義し、`~/.agents/skills` 配下のディレクトリ名からも項目を動的生成する
- `lua/plugins/avante_acp_patch.lua` は ACP の設定選択モデルで、`description` が userdata で返るエージェントや、グループ形式 (`options` の入れ子) を返すエージェントを扱えるようにする。上流の更新に追従できるよう、実行時にソースへ最小差分を当てて preload する
- `lua/plugins/avante_pi_history.lua` は ACP の `rawInput` / `rawOutput` が userdata (空オブジェクト) で返る場合に、履歴の描画が落ちないよう正規化する

### Copilot (標準のインライン補完)

`lua/plugins/copilot.lua` は copilot.lua を使わず、copilot-language-server を `vim.lsp.config('copilot')` で起動し、`vim.lsp.inline_completion` でゴーストテキストを受け取る。

- 有効化しない filetype: `AvanteInput`, `AvantePromptInput`, `AvanteSelectedFiles`, `AvanteSelectedCode`, `markdown`, `gitcommit`, `env`
- `:LspCopilotSignIn` / `:LspCopilotSignOut` はバッファローカルに作成される

### LSP

`lua/plugins/mason-lsp.lua` は `vim.lsp.config` / `vim.lsp.enable` の標準 API を使う。

- `blink.cmp` の capabilities を取得して全サーバに適用 (未読込でも落ちないよう `pcall`)
- `lua_ls` は `diagnostics.globals` に `vim` を追加 (`.luarc.json` と二重の保険)
- 診断は virtual text (`●`, severity sort), float は rounded
- `textDocument/willSaveWaitUntil` を持たず `textDocument/formatting` を持つサーバは `BufWritePre` でフォーマット
- `mason-lspconfig` は `automatic_enable = true` で導入済みサーバを自動有効化

### treesitter

- 使用パーサー: `bash`, `lua`, `markdown`, `markdown_inline`, `regex`, `vim`, `vimdoc`, `python`, `javascript`
- 不足分は `require('nvim-treesitter').install()` で非同期導入
- `FileType` と既存バッファの両方にハイライトを適用し、`Avante` / `AvanteInput` は markdown として扱う
- colorscheme が `industry` のときのみ、`help` / `python` / `bash` / `awk` / `html` で treesitter ハイライトを無効化する (`after_set.lua` が `vim.treesitter.start` をオーバーライド)

## キーマップ

`mapleader` は Space。VSCode 拡張から起動した場合は `keymaps/general.lua` の `setup_vscode` が `VSCodeCall` 経由のキーマップを設定する。

### 一般

| モード | キー | 動作 |
| --- | --- | --- |
| n | `<leader>w` / `<leader>W` | `:w` / `:wq` |
| n | `<leader>q` / `<leader>Q` | `:q` / `:q!` |
| n | `<leader>j` / `<leader>k` | `:bprev` / `:bnext` |
| t | `<C-w><C-n>` | `<C-\><C-n>` (ターミナルノーマルモードへ) |
| v | `$` | `g_` (改行を含めない) |
| n | `<C-n>` | 左上フロート netrw のトグル |

### プラグイン

| モード | キー | 動作 |
| --- | --- | --- |
| n, v | `<C-j>` / `<C-Down>` | 次のコードブロックへ (`edgemotion-j`) |
| n, v | `<C-k>` / `<C-Up>` | 前のコードブロックへ (`edgemotion-k`) |
| n | `<leader>g` / `<leader>e` | `gcc` / `:Partedit` |
| v | `<leader>g` | `gc` |
| n | `<leader>ff` | `find_files` (隠しファイル除外) |
| n | `<leader>fh` | `find_files` (隠しファイル含む) |
| n | `<leader>fb` / `<leader>fr` | バッファ / レジスタ |
| n | `<leader>fg` / `<leader>fc` | `live_grep` / カレントバッファ内検索 |
| n | `<leader>fl` / `<leader>fH` | コマンド / コマンド履歴 |
| n | `<leader>tt` / `<leader>tv` / `<leader>tf` | ターミナル (下 20 行 / 右 60 桁 / フロート) |
| n, v | `<leader>ts` | 現在行 / 選択範囲をターミナルへ送る |
| n | `<leader>h` | `HopAnywhereMW` |
| n | `<leader>cc` / `<leader>ar` | avante チャットのトグル / 履歴クリア |
| n | `<leader>ap` / `<leader>aP` | avante プロバイダ選択 / モデル選択 |
| n | `<leader>p` | クリップボードの画像を貼り付け |
| i | `<C-j>` / `<C-k>` / `<C-q>` | インライン補完の次 / 前 / 破棄 |
| i | `<Tab>` | インライン補完を確定 (候補が無ければ通常の Tab) |
| n, v | `ca` `cd` `cf` `cF` `ch` `cr` `cn` | mini.surround |

補足。

- `<leader>ap` は `AvanteSwitchProvider` を直接叩かず、`vim.ui.select` のコールバック内で旧 ACP クライアントの停止とセッション ID の破棄まで行う。コマンド連結では選択 UI と衝突するため
- `<leader>h` は hop (`HopAnywhereMW`) のみに割り当てる。旧構成の jumpcursor は現行構成で導入していないため設定しない
- ミニマップのトグル (`<leader>mm`) は `mini.map` を導入していないため設定しない

## 外観

- colorscheme は hostname で分岐する

| hostname | colorscheme | termguicolors |
| --- | --- | --- |
| `pop-os` | `iceberg` | 有効 |
| `tekkamelon-pcg-2c7n` | `default` | 無効 |
| その他 (`rin`, `rei` など) | `industry` | 有効 |

- `iceberg` は vim.pack 管理に含まれていないため、`pop-os` で使う場合は別途 colorscheme を導入する必要がある
- `cmdheight` は通常 0。マクロ記録中だけ 1 にし、VSCode 起動時は 1 固定
- `after/plugin/after_set.lua` で以下を設定
    - `CursorLine` をアンダーラインに
    - `Pmenu` / `PmenuSel` を colorscheme 別に上書き
    - `Eyeliner*`, `MiniStatusline*`, `MiniTabline*`, `Avante*`, `ComplHint*` の配色
    - 全 filetype で `formatoptions-=ro` (改行時の自動コメント継続を無効化)

## ファイルタイプとテンプレート

- 拡張子やファイル名による filetype の補正
    - `*conf*`, `*rc` → `conf`
    - `.*shrc` → `sh`, `.vimrc` → `vim`, `.tmux.conf` → `tmux`, `.env*` → `env`
- 新規ファイル作成時に `$HOME/Templates/<lang>.txt` を読み込む
    - 対象: `*.awk`, `*.py`, `*.c`, `*.sh`
    - 実体はリポジトリの `Templates/` にあるため、`~/Templates` へ配置しておく

## 環境変数

| 変数 | 用途 |
| --- | --- |
| `AVANTE_PROVIDER` | avante の既定プロバイダ (必須) |
| `NVIDIA_API_KEY`, `OPENROUTER_API_KEY`, `SAKURA_API_KEY`, `BRAVE_API_KEY` | `goose` プロバイダへ渡す |
| `TAVILY_API_KEY` など | avante の web 検索 (tavily) |

## VSCode (vscode-neovim) 連携

- `vim.g.vscode` が真のとき
    - `lz.n` の `before` フックは何もしない
    - 各プラグインの `after` は早期 return する
    - `keymaps/general.lua` は `VSCodeCall` 経由のキーマップを設定する
- `lua/vscode-neovim_plug.lua` と `lua/vscode-neovim_set.lua` は旧構成で、現在の起動経路からは参照されない

## メンテナンス

- プラグイン更新: Neovim 起動後に `:lua vim.pack.update()`。avante.nvim は更新後に `PackChanged` フックで自動ビルドされる
- LSP サーバの導入: `:Mason`
- パーサの追加: `lua/plugins/treesitter.lua` の `ensure_installed` に追記
- ヘルスチェック: `:checkhealth` (noice は `:checkhealth noice`)
- エラー確認: `:messages`
- 配備: リポジトリの `.config/nvim` を `~/.config/nvim` へ反映し、`diff -rq` で差分が無いことを確認する

## 未使用・レガシー

以下は現在の起動経路から参照されていない。整理の候補。

| ファイル | 由来 |
| --- | --- |
| `init.vim`, `light_init.vim`, `after/plugin/after_set.vim` | vim script 時代の設定 |
| `light_init.lua` | プラグイン無しで起動する軽量設定 (`nvim -u light_init.lua` で明示的に使う) |
| `lua/plugins_old.lua` | lazy.nvim 時代の定義 |
| `lazy-lock.json` | lazy.nvim 時代のロックファイル |
| `lua/pop-os_plug.lua` | jetpack 時代の設定 |
| `lua/vscode-neovim_plug.lua`, `lua/vscode-neovim_set.lua` | 旧 vscode-neovim 用設定 |
| `lua/plugins/codecompanion.lua`, `copilotchat.lua`, `cc_config/*` | codecompanion / CopilotChat 時代の設定 |
| `lua/plugins/neocodeium.lua`, `minuet.lua`, `supermaven.lua` | 補完プラグインの比較用設定 |
| `lua/plugins/minimap.lua`, `mini-files.lua`, `sidekick.lua`, `hardline.lua` | 未導入プラグインの設定 |
| `lua/plugins/telescope-avante.lua` | `telescope.lua` 内でコメントアウト済み |
