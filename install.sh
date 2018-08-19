#!/bin/sh
ln -sf ~/git/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/git/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/git/dotfiles/.vimrc ~/.vimrc
ln -sf ~/git/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/git/dotfiles/.zshrc ~/.zshrc
ln -sf ~/git/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/git/dotfiles/.gitignore_global ~/.gitignore_global

zsh_comp_dir=~/.zsh/completions
zsh_completion=/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion
docker_compose_zsh_completion=/Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion
mkdir -p $zsh_comp_dir
if [ -e $zsh_completion ]; then
    ln -sf $zsh_completion $zsh_comp_dir/_docker
fi
if [ -e $docker_compose_zsh_completion ]; then
    ln -sf $docker_compose_zsh_completion $zsh_comp_dir/_docker-compose
fi
