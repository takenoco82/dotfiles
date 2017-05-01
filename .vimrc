"=============================================================================
" Basic {{{

set nocompatible " to use many extensions of Vim.
"}}}

"=============================================================================
" Encoding {{{

" Vim内部で使われる文字エンコーディング
set encoding=utf-8

" 文字コードの判定
if has('iconv')
  set fileencodings=ucs-bom,iso-2022-jp,euc-jp,cp932,utf-8
endif

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 改行コードの判定
set fileformats=dos,unix,mac

" □や△などを全角幅で表示する
set ambiwidth=double
"}}}

"=============================================================================
" Options {{{

if has('win32') || has('win64')
  let $MYVIMRUNTIME = $HOME . '/vimfiles'
else
  let $MYVIMRUNTIME = $HOME . '/.vim'
endif

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=4
" タブをスペースに展開しない
set noexpandtab
" 改行時に新しい行のインデントを前行のインデントと同じにする
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 括弧入力時に対応する括弧を表示
set showmatch
" 折り畳みの種類 (marker:マーカーで折り畳みを指定する。)
set foldmethod=marker
" 行頭行末で前／次行に移動できるキー
set whichwrap=b,s,h,l
" diffモード時のオプション
"   filter: 片方だけに存在する行がある場合、行の存在しないウィンドウの方に埋め立て用の行を表示する
"   vertical: 明示的に指定されない限り、縦分割して表示する
set diffopt=filler,vertical
" % で日本語のカッコもジャンプできるようにする
set matchpairs&
set matchpairs+=（:）,「:」,『:』,【:】
" C-a, C-x の対象
set nrformats=alpha,hex

"-----------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を表示
set number
" ルーラーを表示
set ruler
" 不可視文字(タブや行末、スペースなど)を表示
set list
" 不可視文字の表示設定
set listchars=tab:>-,trail:-,extends:<,nbsp:.
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
" 折り返された行をインデントして表示する
set breakindent
" カーソル行を強調表示する
set cursorline
" 縦分割するときに新しいウィンドウを右に開く
set splitright
" 横分割するときに新しいウィンドウを下に開く
set splitbelow

"-----------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" 保存せずにバッファを切り替えられるようにする
set hidden
" 外部でファイルが変更された場合、自動的に読み直す
set autoread
" 終了時に保存されていないファイルに対し保存の確認を行う
set confirm
" バックアップファイルを作成しない
set nobackup

if has('persistent_undo')
  " アンドゥファイルを作成する
  set undofile
  " アンドゥファイル用のディレクトリ
  set undodir=$MYVIMRUNTIME/undo
endif

" スワップファイルを作成する
set swapfile
" スワップファイル用ディレクトリ
set directory=$MYVIMRUNTIME/tmp

"-----------------------------------------------------------------------------
" 全角スペースの表示
" http://inari.hatenablog.com/entry/2014/05/05/231307
"
function! IdeographicSpace()
    highlight IdeographicSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup IdeographicSpace
        autocmd!
        autocmd ColorScheme * call IdeographicSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('IdeographicSpace', '　')
    augroup END
    call IdeographicSpace()
endif
"}}}

"=============================================================================
" Mappings {{{

" :helpを3倍の速度で引く
" http://whileimautomaton.net/2008/08/vimworkshop3-kana-presentation
nnoremap <C-h>  :<C-u>Vhelp<Space>
nnoremap g<C-h>  :<C-u>helpgrep<Space>

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

" スクラッチバッファを作成する
nnoremap <C-s>  :<C-u>Scratch<CR>
"}}}

"=============================================================================
" Commands {{{

command! Vivimrc  edit $MYVIMRC
command! Vigvimrc edit $MYGVIMRC

command! Reloadvimrc  source $MYVIMRC | if has('gui_running') | source $MYGVIMRC | endif
command! Reloadgvimrc source $MYGVIMRC

" 文字エンコーディングを指定してファイルを開く
" https://github.com/kana/config/blob/master/vim/personal/dot.vimrc
command! -bang -bar -complete=file -nargs=? Cp932     edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Eucjp     edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Utf8      edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Jis   Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>

" 文字エンコーディングを変換する
command! Encode2Cp932     setlocal fileencoding=cp932
command! Encode2Eucjp     setlocal fileencoding=euc-jp
command! Encode2Iso2022jp setlocal fileencoding=Iso2022jp
command! Encode2Utf8      setlocal fileencoding=utf-8 nobomb
command! Encode2Utf8Bom   setlocal fileencoding=utf-8 bomb
command! Encode2Utf16     setlocal fileencoding=utf-16le
command! Encode2Sjis  Encode2Cp932
command! Encode2Jis   Encode2Iso2022jp

" 改行コードを変換する
command! Format2Dos   setlocal fileformat=dos
command! Format2Unix  setlocal fileformat=unix
command! Format2Mac   setlocal fileformat=mac

" 現在のバッファと元のファイルの差分を見る
command! DiffOrig  vert new | set bt=nofile | r ++edit # | 0d_
  \ | diffthis | wincmd p | diffthis

" Vim のヘルプを右側で開いたり、タブで開いたりする
" http://haya14busa.com/reading-vim-help/
command! -complete=help -nargs=? Vhelp  vertical belowright help <args>
command! -complete=help -nargs=? Tabhelp  tab help <args>

"}}}

"=============================================================================
" Scripts {{{

"-----------------------------------------------------------------------------
" dein {{{

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
  call dein#add('Shougo/vimfiler.vim', {'depends' : 'Shougo/unite.vim'})
  call dein#add('Shougo/neomru.vim', {'depends' : 'Shougo/unite.vim'})
  call dein#add('Shougo/unite-outline', {'depends' : 'Shougo/unite.vim'})

  call dein#add('Shougo/vimproc.vim', {
        \ 'build': {
        \     'mac': 'make -f make_mac.mak',
        \     'linux': 'make',
        \     'unix': 'gmake',
        \    },
        \ })

  call dein#add('thinca/vim-ft-help_fold', {'on_ft' : 'help'})

  call dein#add('Lokaltog/vim-easymotion')

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
augroup LoadColorscheme
  autocmd!
  autocmd VimEnter * nested colorscheme solarized
augroup END

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"}}}

"-----------------------------------------------------------------------------
" vimfiler {{{

let g:vimfiler_as_default_explorer = 1
"}}}

"-----------------------------------------------------------------------------
" unite {{{

" http://www.karakaram.com/unite
" http://d.hatena.ne.jp/osyo-manga/20130307/1362621589

" プレフィックスキー
nnoremap [unite] <Nop>
nmap <Space>j [unite]

" uniteの設定用ディレクトリ
let g:unite_data_directory = expand('~/.cache/unite')

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
" アウトライン
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline outline -no-quit -vertical -winwidth=40<CR>
" grep
nnoremap <silent> [unite]/ :<C-u>Unite grep -no-quit<CR>

"uniteを開いている間のキーマッピング
augroup UniteSettings
  autocmd!
  autocmd FileType unite call s:unite_my_settings()
augroup END
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
"}}}

"-----------------------------------------------------------------------------
" neomru {{{

" 最近開いたファイル履歴の保存数
let g:neomru#file_mru_limit = 100
" シンボリックリンクも対象にする
let g:neomru#follow_links = 1
"}}}

"-----------------------------------------------------------------------------
" easymotion {{{
" http://haya14busa.com/mastering-vim-easymotion/

" デフォルトマッピングを無効化
let g:EasyMotion_do_mapping = 0
" Enter／Space で1つ目のマッチ(g:EasyMotion_keys の最初の文字)に移動
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
" smartcase で検索
let g:EasyMotion_smartcase = 1

" 2-key Find Motion
map <Space>f <Plug>(easymotion-s2)
" n-key Find Motion
nmap <Space>/ <Plug>(easymotion-sn)
xmap <Space>/ <Plug>(easymotion-sn)
omap <Space>/ <Plug>(easymotion-tn)
"}}}
"}}}

"=============================================================================
" Filetypes {{{

" help
augroup HelpSettings
  autocmd!
  " q で help を閉じる
  autocmd FileType help  nnoremap <buffer> q <C-w>c
augroup END

"}}}

"=============================================================================
" Autocommands {{{

" hlepgrep で quickfix を自動で開く
function! s:AutoQuickfix()
  if empty(getqflist())
    redraw
  else
    copen
  endif
endfunction
augroup OpenQuickfix
  autocmd!
  autocmd QuickfixCmdPost helpgrep  call <SID>AutoQuickfix()
augroup END
"}}}

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
