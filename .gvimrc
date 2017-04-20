"===============================================================================
" Options
"===============================================================================
"-------------------------------------------------------------------------------
" フォント設定:
"
if has('win32')
  " Windows用
  set guifont=MS_Gothic:h11:cSHIFTJIS
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('gui_macvim')
  set guifont=Osaka-Mono:h12
elseif has('mac')
  set guifont=Osaka−等幅:h12
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif

"-------------------------------------------------------------------------------
" ウインドウに関する設定:
"
" ウインドウの幅
set columns=180
" ウインドウの高さ
set lines=60
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
if has('win32') || has('win64')
  set cmdheight=2
endif

"---------------------------------------------------------------------------
" メニューに関する設定:
"
" GUIのどのコンポーネントとオプションを使用するかを設定
"   g: 無効のメニュー項目を灰色で表示する
"   r: 右スクロールバーを常に表示する
"   L: 垂直分割されたウィンドウがあるときのみ、左スクロールバーを表示する
set guioptions=grL


" hardcopy
let $PRINTRC = $MYVIMRUNTIME . '/macros/printrc.vim'
nnoremap <silent> <Leader>ep  :<C-u>edit $PRINTRC<CR>
nnoremap <silent> <Leader>sp  :<C-u>source $PRINTRC<CR>


