"===============================================================================
" Basic
"===============================================================================
set nocompatible " to use many extensions of Vim.


"===============================================================================
" Encoding
"===============================================================================
if &encoding !=# 'utf-8'
  set fileencodings&
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
set fileformats=dos,unix,mac
if exists('&ambiwidth')
  set ambiwidth=double
endif


"===============================================================================
" Options
"===============================================================================
if has('win32') || has('win64')
  let $MYVIMRUNTIME = $HOME . '/vimfiles'
else
  let $MYVIMRUNTIME = $HOME . '/.vim'
endif

"------------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" インクリメンタルサーチをする
set incsearch
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索時にファイルの最後まで行ったら最初に戻る
set wrapscan
" 検索にマッチする箇所を強調表示する
set hlsearch

"------------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=4
" タブをスペースに展開しない
set noexpandtab
" 自動的にインデントする
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 括弧入力時に対応する括弧を表示
set showmatch
" 折り畳みの種類 (marker:マーカーで折り畳みを指定する。)
set foldmethod=marker

"------------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示
set number
" ルーラーを表示
set ruler
" タブや改行を表示
set list
" どの文字でタブや改行を表示するかを設定
set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示
set wrap
" 常にステータス行を表示
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" コマンドライン補完するときに強化されたものを使う
set wildmenu
" タイトルを表示
set title

"------------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成する
set backup
" バックアップファイル用ディレクトリ
set backupdir=$MYVIMRUNTIME/backup
" アンドゥファイルを作成する
set undofile
" アンドゥファイル用のディレクトリ
set undodir=$MYVIMRUNTIME/backup
" スワップファイルを作成する
set swapfile
" スワップファイル用ディレクトリ
set directory=$MYVIMRUNTIME/tmp

"===========================================================================
" Mappings
"===========================================================================
" j,k は論理行で移動
nnoremap j  gj
nnoremap k  gk
vnoremap j  gj
vnoremap k  gk

" カーソル以降をヤンク
nnoremap Y  y$

" コマンドライン操作
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
cnoremap <C-f>  <Right>
cnoremap <C-b>  <Left>
cnoremap <M-w>  <S-Right>
cnoremap <M-b>  <S-Left>
cnoremap <C-q>  <C-f>
cnoremap <C-y>  <C-r>*

" タブ操作
nnoremap <C-Tab>  gt
nnoremap <C-S-Tab>  gT

" 選択したキーワードで検索
vnoremap <silent> *  y/<C-r>=escape(@", '\\/.*$^~[]')<CR><CR>
vnoremap <silent> #  y?<C-r>=escape(@", '\\/.*$^~[]')<CR><CR>

" 最後の置換を繰り返す
vnoremap &  :&<CR>
vnoremap g&  :&&<CR>

" ノーマルモードのまま空行を挿入する
nnoremap <silent> go  :<C-u>call append(expand('.'), '')<CR>j

" 検索結果ハイライトを消す
nnoremap <Esc><Esc>  :<C-u>nohlsearch<CR><Esc>


"===========================================================================
" Commands
"===========================================================================
command! Vivimrc  :edit $MYVIMRC
command! Vigvimrc  :edit $MYGVIMRC

command! Reloadvimrc  :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
command! Reloadgvimrc  :<C-u>source $MYGVIMRC<CR>


"===========================================================================
" Scripts
"===========================================================================
"dein Scripts----------------------------- {{{
if &compatible
  set nocompatible               " Be iMproved
endif

" プラグインをインストールするディレクトリ
let s:plugin_dir = expand('~/.vim/bundles')
" dein.vim をインストールするディレクトリ
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'

" Required:
execute 'set runtimepath+=' . s:dein_dir

" dein.vimがまだ入ってなければ 最初に`git clone`
if !isdirectory(s:dein_dir)
  call mkdir(s:dein_dir, 'p')
  silent execute printf('!git clone %s %s', 'https://github.com/Shougo/dein.vim', s:dein_dir)
endif

" Required:
if dein#load_state(s:plugin_dir)
  call dein#begin(s:plugin_dir)

  " Let dein manage dein
  " Required:
  call dein#add(s:dein_dir)

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/neomru.vim')
  call dein#add('Shougo/vimfiler.vim')

  " colorscheme
  call dein#add('altercation/vim-colors-solarized')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on

" カラースキーマ の設定
syntax enable
set background=dark
augroup load_colorscheme
  autocmd!
  autocmd VimEnter * nested colorscheme solarized
augroup END

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts------------------------- }}}


"vimfiler Scripts------------------------- {{{
let g:vimfiler_as_default_explorer = 1

"End vimfiler Scripts--------------------- }}}


"unite Scripts---------------------------- {{{
" http://www.karakaram.com/unite
" http://d.hatena.ne.jp/osyo-manga/20130307/1362621589

" プレフィックスキー
nnoremap [unite] <Nop>
nmap <Space>j [unite]

" 現在開いているファイルのディレクトリ下のファイル一覧。
" 開いていない場合はカレントディレクトリ
nnoremap <silent> [unite]j :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]h :<C-u>Unite file_mru<CR>
" ブックマーク一覧
nnoremap <silent> [unite]f :<C-u>Unite bookmark<CR>
" ブックマークに追加
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>

"uniteを開いている間のキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  "ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  "入力モードのときctrl+wでバックスラッシュも削除
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  "ctrl+sで縦に分割して開く
  nnoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  inoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
  "ctrl+vで横に分割して開く
  nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  "ctrl+tで新しいタブで開く
  nnoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
  inoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
  "ctrl+oでvimfilerで開く
  nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('vimfiler')
  inoremap <silent> <buffer> <expr> <C-o> unite#do_action('vimfiler')
endfunction"}}}

"End unite Scripts------------------------ }}}


"neomru Scripts--------------------------- {{{
" 最近開いたファイル履歴の保存数
let g:neomru#file_mru_limit = 100
" シンボリックリンクも対象にする
let g:neomru#follow_links = 1

"End neomru Scripts----------------------- }}}
