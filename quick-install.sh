#!/bin/bash
if ! `which apm >/dev/null 2>&1`; then
  if ! `which git >/dev/null 2>&1`; then
    sudo pacman -S git --noconfirm --force
  fi
  git clone https://github.com/fusion809/PKGBUILDs $HOME/GitHub/mine/PKGBUILDs
  cd $HOME/GitHub/mine/PKGBUILDs/atom-editor-sync
  makepkg -si --noconfirm
  cd -
fi

cd ~/.atom
git init
git remote add origin git@github.com:fusion809/atom.git
git pull origin master
git submodule update --init --recursive
cd -
