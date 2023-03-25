" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
  colorscheme industry
endif

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
" set cursorcolumn

" ヤンクをクリップボードに貼り付け
set clipboard=unnamedplus

" netrwを有効化
filetype plugin on
	
	" プレビューウィンドウを垂直分割で表示
	let g:netrw_preview=1

" クリップボード連携
" set clipboard+=unnamed

" swapファイルを別ディレクトリに作成
set directory=/tmp

" 分割方向を下と右
set splitbelow
set splitright

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

	"ターミナルを起動
	nnoremap <leader>t :terminal<Enter>
	nnoremap <leader>T :tabnew<Enter>
	map <leader>m :make<Enter>  

	"バッファの切り替え
	nnoremap <leader>j :bprev<CR>
	nnoremap <leader>k :bnext<CR>
" ====== leaderの設定ここまで ====== 


" ====== jetpackの設定 =======
call jetpack#begin()

	Jetpack 'tani/vim-jetpack', {'opt': 1}
	Jetpack 'vim-airline/vim-airline-themes'
	Jetpack 'vim-airline/vim-airline'
	Jetpack 'scrooloose/nerdtree'

	" 以下の機能は0.7.0から
	Jetpack 'nvim-lua/plenary.nvim'
	Jetpack 'nvim-telescope/telescope.nvim'

call jetpack#end()
" ====== jetpackの設定ここまで =======


" ====== NERDTreeの設定 ======
map <C-n> :NERDTreeToggle<CR>
" ====== NERDTreeの設定ここまで ======


" ====== airlineの設定 ======
" テーマの指定
" let g:airline_theme = 'base16_adwaita'               
let g:airline_theme = 'dark_minimal'               

" タブラインを表示
let g:airline#extensions#tabline#enabled = 1 
" ====== airlineの設定ここまで ======


" ====== telescopeの設定 ======
" leader+fでファイルを検索
nnoremap <leader>f <cmd>Telescope find_files hidden=false theme=get_dropdown<cr>

" leader+Fで隠しファイルごと検索
nnoremap <leader>F <cmd>Telescope find_files hidden=true theme=get_dropdown<cr>
" leader+bでバッファを検索
nnoremap <leader>b <cmd>Telescope buffers theme=get_dropdown<cr>
" ====== telescopeの設定ここまで ======


" ====== neovim固有の設定 ======
if has('nvim')

	" 配色の設定
	colorscheme industry

	" ターミナルの起動
	nnoremap <leader>t :Bterm<Enter>
	nnoremap <leader>v :Vterm<Enter>
	command! -nargs=* Bterm split | terminal <args>
	command! -nargs=* Vterm vsplit | terminal <args>

	" 分割したウィンドウの移動
	tnoremap <C-w><C-n> <C-\><C-n>

	" ターミナル起動時に行番号を非表示
    autocmd TermOpen * setlocal norelativenumber
    autocmd TermOpen * setlocal nonumber

endif
" ====== neovim固有の設定ここまで ======

