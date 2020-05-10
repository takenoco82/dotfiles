#!/bin/bash

#
# Macの初期化処理
#

set -eu

LAUNCH_AGENTS_DIR="$HOME"/Library/LaunchAgents
SCRIPT_DIR=$(cd $(dirname $0); pwd)
MUSTACHE_FILES="${SCRIPT_DIR}/mac/launchd/*.mustache"

function exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

function setup_dock() {
  # Automatically hide
  defaults write com.apple.dock autohide -bool true
  # Set the icon size
  defaults write com.apple.dock tilesize -int 40
  # Position
  defaults write com.apple.dock orientation -string "right"

  # すべての（デフォルトの）アプリアイコンをDockから消去する
  defaults write com.apple.dock persistent-apps -array
}

function setup_finder() {
  # show litsview as default
  defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"

  # Show Path bar
  defaults write com.apple.finder ShowPathbar -bool true
  # Show Side bar
  defaults write com.apple.finder ShowSidebar -bool true
  # Show Status bar
  defaults write com.apple.finder ShowStatusBar -bool true
  # Show Tab bar
  defaults write com.apple.finder ShowTabView -bool true
  # ディレクトリを先に表示する
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # 隠しファイルを表示する
  defaults write com.apple.finder AppleShowAllFiles -boolean true

  # 拡張子を常に表示
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # 共有フォルダで .DS_Store ファイルを作成しない
  defaults write com.apple.desktopservices DSDontWriteNetworkStores true

  # Show the ~/Library directory
  chflags nohidden ~/Library
}

function setup_battery() {
  # Show the battery percentage
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"
}

function setup_datetime() {
  # Format
  defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  h:mm a"
}

function setup_security_privacy() {
  # ファイアーウォールをオンにする
  sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
}

function setup_keyboard() {
  # Use F1, F2 etc. keys as standard function keys
  defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
}

function setup_trackpad() {
  # Tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Enable Three finger drag
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
}

function setup_system_preferences() {
  echo "System Preferences"

  setup_dock
  setup_finder
  setup_battery
  setup_datetime
  setup_security_privacy
  setup_keyboard
  setup_trackpad

  killall Dock
  killall Finder
  killall SystemUIServer

  echo "System Preferences completed successfully"
}

function install_xcode_command_line_tools() {
  echo "Instaling Xcode Command Line Tools"

  if exists "xcode-select"; then
    echo "Xcode Command Line Tools: already exists"
    return
  fi
  xcode-select --install

  echo "Instaling Xcode Command Line Tools completed successfully"
}

function install_package_manager() {
  echo "Instaling Package Manager"

  # # Homebrewでインストールする際のパーミンションエラー対策
  # sudo chown -R $(whoami):admin /usr/local
  # sudo chmod -R g+w /usr/local

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew update
  brew upgrade

  brew install cask
  brew install mas

  echo "Instaling Package Manager completed successfully"
}

function install_packages() {
  echo "Instaling Packages"

  brew install awscli
  brew install git
  brew install mycli
  brew install poetry
  brew install pyenv
  brew install starship
  brew install vim

  brew cask install alfred
  # brew cask install amazon-workspaces
  brew cask install appcleaner
  brew cask install dash
  brew cask install docker
  brew cask install google-backup-and-sync
  brew cask install google-chrome
  brew cask install google-japanese-ime
  brew cask install hyperswitch
  brew cask install iterm2
  brew cask install microsoft-teams
  brew cask install mysqlworkbench
  brew cask install onedrive
  brew cask install spectacle
  brew cask install tableplus
  brew cask install visual-studio-code
  brew cask install vlc
  brew cask install webex-meetings

  mas install 568494494  # Pocket
  mas install 803453959  # Slack
  mas install 1278508951  # Trello

  echo "Instaling Packages completed successfully"
}

function install_fonts() {
  echo "Instaling Fonts"

  brew tap homebrew/cask-fonts
  brew cask install font-source-han-code-jp

  local temp_dir=$(mktemp -d)
  (
    cd $temp_dir

    # https://github.com/powerline/fonts
    git clone https://github.com/powerline/fonts.git --depth=1
    # install
    cd fonts
    ./install.sh
    # clean-up a bit
  )
  rm -rf $temp_dir

  echo "Instaling Fonts completed successfully"
}

# https://hnakamur.github.io/blog/2015/04/06/install-apps-without-homebrew-cask/
function install_keyhac() {
  echo "Instaling Keyhac"

  local download_url=http://crftwr.github.io/keyhac/mac/download/Keyhac-1.10.dmg
  local dmg_file=${download_url##*/}

  curl -LO $download_url
  local mount_dir=`hdiutil attach $dmg_file | awk -F '\t' 'END{print $NF}'`
  sudo /usr/bin/ditto "$mount_dir/Keyhac.app" "/Applications/Keyhac.app"
  hdiutil detach "$mount_dir"
  rm $dmg_file

  echo "Instaling Keyhac completed successfully"
}

# https://github.com/tests-always-included/mo
function install_mo() {
  echo "Instaling Mo"

  # Download
  curl -sSL https://git.io/get-mo -o mo

  # Make executable
  chmod +x mo

  # Move to the right folder
  sudo mv mo /usr/local/bin/

  which mo

  echo "Instaling Mo completed successfully"
}

function install_plists() {
  echo "Instaling scripts to launchd"

  mkdir -p "$LAUNCH_AGENTS_DIR"
  mkdir -p "$LAUNCH_AGENTS_DIR/log"

  for mustache_file in $MUSTACHE_FILES
  do
    local file_name_wo_ext=$(basename "$mustache_file" .mustache)
    local plist_file="$LAUNCH_AGENTS_DIR"/"$file_name_wo_ext"

    mo "$mustache_file" > $plist_file
    launchctl load $plist_file
  done

  echo "Instaling scripts to launchd completed successfully"
}

function main() {
  setup_system_preferences
  # install_xcode_command_line_tools
  # install_package_manager
  # install_packages
  # install_fonts
  # install_keyhac
  # install_mo
  # install_plists
}

main
