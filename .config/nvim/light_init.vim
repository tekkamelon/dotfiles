" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.

" 配色の設定
if has("syntax")
  syntax on
  colorscheme industry
  " colorscheme ron
endif

" truecolorの設定
set termguicolors

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)
set number
" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
set buftype=

" tabの幅を4に設定
set tabstop=4
set shiftwidth=4

" カーソルラインを表示
set cursorline   

" 一度カーソルラインをリセット
hi clear CursorLine

" カーソルラインをアンダーラインに設定
hi CursorLine gui=underline cterm=underline

" swapファイルを別ディレクトリに作成
set directory=/tmp

" 分割方向を下と右
set splitbelow
set splitright

" 分割したウィンドウの移動
tnoremap <C-w><C-n> <C-\><C-n>

" ====== ターミナルの設定 ======
" ターミナル起動時に行番号を非表示
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal nonumber
" ====== ターミナルの設定ここまで ======


" ====== leaderをspaceに設定 ====== 
let mapleader="\<Space>"
	" ノーマルモード時のコメントアウト
	map <leader>/ ^i//<ESC>
	map <leader>2 ^i" <ESC>
	map <leader>3 ^i# <ESC>

	" ビジュアルモード時のコメントアウト
	vmap <leader>/ :'<,'>normal i//<Enter>
	vmap <leader>2 :'<,'>normal i" <Enter>
	vmap <leader>3 :'<,'>normal i# <Enter>

	" spaceを使い保存及び終了
	map <leader>w :w<Enter>
	map <leader>W :wq<Enter>
	map <leader>q :q<Enter>
	map <leader>Q :q!<Enter>

	" ターミナルの設定
	" "Bterm"コマンドの設定,ターミナルを下画面に高さを7行分下げた状態で起動
	command! -nargs=* Bterm split | resize -7 | terminal <args>
	" "Vterm"の設定,ターミナルを右半分に起動
	command! -nargs=* Vterm vsplit | terminal <args>

	" 上記コマンドを起動
	nnoremap <leader>t :Bterm<Enter>
	nnoremap <leader>v :Vterm<Enter>

	" コンパイル
	map <leader>m :make<Enter>  

	"バッファの切り替え
	nnoremap <leader>j :bprev<CR>
	nnoremap <leader>k :bnext<CR>
" ====== leaderの設定ここまで ====== 
