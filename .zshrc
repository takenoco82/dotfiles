#=============================================================================
# Autoloads

# 色を使用出来るようにする
autoload -Uz colors
colors

# Docker関連コマンドの補完を行う
# https://chopschips.net/blog/2018/04/17/docker-completion/
if [ -e ~/.zsh/completions ]; then
  fpath=(~/.zsh/completions $fpath)
fi

# 自動補完を有効にする
autoload -Uz compinit
compinit

# リポジトリ情報を取得する
autoload -Uz vcs_info


#=============================================================================
# Key Bindings

# emacsモードを使う
bindkey -e
# history search
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward


#=============================================================================
# Environment Variables
# https://wiki.archlinuxjp.org/index.php/Zsh
#
# 文字コード
export LANG=ja_JP.UTF-8

# 標準エディタを設定する
export EDITOR=vim

# pyenvを使えるようにする
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# nodebrewを使えるようにする
export PATH=$HOME/.nodebrew/current/bin:$PATH

# Goのパスを通す
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# JAVA_HOMEを設定
export JAVA_HOME=$(/usr/libexec/java_home)

#-----------------------------------------------------------------------------
# ヒストリの設定

# 履歴ファイルの保存先
export HISTFILE=~/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# HISTFILE で指定したファイルに保存される履歴の件数
export SAVEHIST=1000

#-----------------------------------------------------------------------------
# ls コマンドのカラー表示
# http://post.simplie.jp/posts/60
export CLICOLOR=true
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'


#=============================================================================
# Options
# http://zsh.sourceforge.net/Doc/Release/Options.html
# http://news.mynavi.jp/column/zsh/005/

#-----------------------------------------------------------------------------
# Changing Directories

# ディレクトリ名だけで cd する
setopt AUTO_CD
# cd したらカレントディレクトリを pushd する
setopt AUTO_PUSHD
# 同じディレクトリを重複して pushd しない
setopt PUSHD_IGNORE_DUPS

#-----------------------------------------------------------------------------
# Completion

# 補完候補を一覧で表示する
setopt AUTO_LIST
# Tabキーを連打して補完候補を移動する
setopt AUTO_MENU
# ディレクトリを補完すると末尾に / を付加する
setopt AUTO_PARAM_SLASH
# 補完候補を詰めて表示する
setopt LIST_PACKED
# ファイルの末尾に種別の識別記号をつける
setopt LIST_TYPES
# 大文字を入力した時は小文字の候補を補完しない
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
# aws-cliの補完を行う
# https://qiita.com/mojito/items/5e0181615e48d3e6109e
if [ -e ~/.pyenv/shims/aws_completer ]; then
  source "$(pyenv which aws_zsh_completer.sh)"
fi

#-----------------------------------------------------------------------------
# Expansion and Globbing

#-----------------------------------------------------------------------------
# History

# 同じコマンドは履歴に保存しない(古い履歴を削除する)
setopt HIST_IGNORE_ALL_DUPS
# 行頭がスペースのコマンドは履歴に保存しない
setopt HIST_IGNORE_SPACE
# history コマンドを履歴に保存しない
setopt HIST_NO_STORE
# 履歴をファイルにすぐ書き込む(通常はシェル終了後に書き込む)
setopt INC_APPEND_HISTORY
# 履歴を共有する
setopt SHARE_HISTORY

#-----------------------------------------------------------------------------
# Input/Output

# コマンドのスペルミスを指摘する
setopt CORRECT
# べての引数に対してスペルミスを指摘する
setopt CORRECT_ALL
# Ctrl+s／Ctrl+q による画面ロック／解除を使わない
setopt NO_FLOW_CONTROL
# Ctrl+d で終了しない
setopt IGNORE_EOF
# 対話的シェル(Interactive)でも#以降をコメントとみなす
setopt INTERACTIVE_COMMENTS
# 日本語ファイル名を表示可能にする(既に問題ない場合には必要ない)
#setopt PRINT_EIGHT_BIT
# 正常終了しなかった場合に終了コード($?)を表示する
setopt PRINT_EXIT_VALUE


#=============================================================================
# Aliases

alias ls="ls -FG"
alias la="ls -FGa"
alias ll="ls -FGla"
alias lt="ls -FGlat"
alias mkdir="mkdir -p"
# alias rm="rm -i"
# alias mv="mv -i"
# alias cp="cp -i"

if [ -f /Applications/MacVim.app/Contents/MacOS/Vim ]; then
  alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
  alias vi=vim
fi


#=============================================================================
# Functions

# オプション一覧を表示する
# http://qiita.com/mollifier/items/26c67347734f9fcda274
function showoptions() {
  set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
}


#=============================================================================
# Otherwize

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

#-----------------------------------------------------------------------------
# プロンプト

# Starship
# https://github.com/starship/starship
eval "$(starship init zsh)"

eval "$(nodenv init -)"
