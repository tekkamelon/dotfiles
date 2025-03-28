# dotfiles
自分用の設定ファイル

## Template

- neovimで使用するテンプレート

## .Xresources

- urxvtの配色などの設定

## .fbtermrc

- fbtermの設定

## .tigrc

- tigの設定

## .tmux.conf

- tmuxの設定

## .tmux

- .tmux.confで使用するスクリプト

## .*shrc

### .shrc

- 各シェル共通の設定

- 各種シェル固有の設定

    - .bashrc

    - .kshrc

    - .mkshrc

    - .yashrc

## ncmpcpp

### bindings

- ncmpcppのキーバインドの設定

### config

- ncmpcppの配色などの設定

## .config

### user-dirs-.dirs

- "XDG_xxx_DIR"の設定

### i3

#### config

- i3ウィンドウマネージャーのキーバインドや自動実行するソフトの設定

### nvim

#### init.vim

- neovimの起動時に読み込まれるキーバインドやプラグインなどの設定,現在更新予定なし

#### init.lua

- neovimの起動時に読み込まれる設定

#### light_init.vim

- neovimをプラグイン無しで起動する際に使用,現在更新予定なし

#### light_init.lua

- neovimをプラグイン無しで起動する際に使用

#### .luarc.json

- luaのlspの設定

#### after/plugin/

- after_set.vim

    - プラグインの後に読み込まれる設定,現在更新予定なし

- after_set.lua

    - プラグインの後に読み込まれる設定

#### lua/

- plugins.lua

    - プラグインの読み込みなどの設定

- pop-os.lua

    - pop-os用のプラグインの設定,更新予定なし

- vscode-neovim_plug.lua

    - vscode-neovimから起動した際に読み込まれるプラグインの設定,更新予定なし

- vscode-neovim_set.lua

    - vscode-neovimのキーバインドの設定,更新予定なし

##### plugins/

- 各種プラグインの設定

- copilot.lua

- copilotchat.lua

- hlchunk.lua

##### keymaps/

- キーマップの設定

- general.lua

    - プラグイン以外のキーマップ

- plugins.lua

    - プラグインのキーマップ

### ranger

- rangerの各種設定ファイル集

### Code/User

- settings.json

    - vscodeの設定ファイル

### alacritty

- alacritty.toml

    - alacrittyの設定ファイル

### mpd

- mpd.conf

    - mpdの設定ファイル
