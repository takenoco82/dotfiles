#!/bin/bash

#
# dotfiles に対し、ホームディレクトリにシンボリックリンクを貼る
#

set -eu

SCRIPT_DIR=$(cd $(dirname $0); pwd)
DOTFILES="${SCRIPT_DIR}/.??*"

for dotfile in $DOTFILES
do
    local file_name=$(basename "$dotfile")
    [[ $file_name == ".DS_Store" ]] && continue
    [[ $file_name == ".git" ]] && continue
    [[ $file_name == ".gitignore" ]] && continue

    # echo "$dotfile"
    ln -snfv "$dotfile" "${HOME}"/"${file_name}"
done
