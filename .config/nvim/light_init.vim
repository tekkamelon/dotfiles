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
  colorscheme default
endif

" 標準プラグインの読込の停止
let g:did_install_default_menus = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

" truecolorの設定
" set termguicolors

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

" swapファイルを別ディレクトリに作成
set directory=/tmp

" 分割方向を下と右
set splitbelow
set splitright

" 分割したウィンドウの移動
tnoremap <C-w><C-n> <C-\><C-n>


" ====== leaderをspaceに設定 ====== 
let mapleader="\<Space>"
	" ノーマルモード時のコメントアウト
	" map <leader>/ ^i// <ESC>
	" map <leader>2 ^i" <ESC>
	" map <leader>3 ^i# <ESC>

	" ビジュアルモード時のコメントアウト
	vmap <leader>/ :'<,'>normal i// <Enter>
	vmap <leader>2 :'<,'>normal i" <Enter>
	vmap <leader>3 :'<,'>normal i# <Enter>

	" spaceを使い保存及び終了
	map <leader>w :w<Enter>
	map <leader>W :wq<Enter>
	map <leader>q :q<Enter>
	map <leader>Q :q!<Enter>

	"バッファの切り替え
	nnoremap <leader>j :bprev<CR>
	nnoremap <leader>k :bnext<CR>
" ====== leaderの設定ここまで ====== 
