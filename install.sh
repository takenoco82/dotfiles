#!/bin/bash

#
# dotfiles のインストール、OSのセットアップを行う
#

set -eu

GITHUB_DOTFILES_URL=https://github.com/takenoco82/dotfiles.git

PROJECT_DIR="$HOME"/dotfiles
SCRIPT_DIR=$(cd $(dirname $0); pwd)
DOTFILES="${SCRIPT_DIR}/.??*"


function exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

function download_dotfiles() {
  echo "Download dotfiles"

  if [ -d "$PROJECT_DIR" ]; then
    echo "$PROJECT_DIR: already exists"
    return
  fi

  if exists "git"; then
    git clone "$GITHUB_DOTFILES_URL" "$PROJECT_DIR"
  else
    # TODO: download by curl
    echo "git not found!"
    exit 1
  fi

  echo "Download dotfiles completed successfully"
}

function install_dotfiles() {
  echo "Instaling dotfiles"

  for dotfile in $DOTFILES
  do
      local file_name=$(basename "$dotfile")
      [[ $file_name == ".DS_Store" ]] && continue
      [[ $file_name == ".git" ]] && continue
      [[ $file_name == ".gitignore" ]] && continue

      # echo "$dotfile"
      ln -snfv "$dotfile" "${HOME}"/"${file_name}"
  done

  echo "Instaling dotfiles completed successfully"
}

function setup() {
  echo "Set up"

  local platform=$1

  case "$platform" in
    "Darwin" )
      . "$SCRIPT_DIR"/setup/macos.sh
      ;;
    * )
      echo "$platform: unsupported platform!"
      exit 1
  esac

  echo "Set up completed successfully"
}

function main() {
  local platform=$(uname)

  download_dotfiles
  install_dotfiles
  setup $platform
}

main
