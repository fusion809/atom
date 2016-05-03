#!/bin/bash
if ! `which apm >/dev/null 2>&1`; then
  if ! `which git >/dev/null 2>&1`; then
    sudo pacman -S git --noconfirm --force
  fi
  export PKG=$HOME/GitHub/mine/PKGBUILDs
  if ! [[ -d $PKG ]]; then
    git clone https://github.com/fusion809/PKGBUILDs $PKG
  else
    cd $PKG
    git pull origin master
    cd -
  fi
  cd $PKG/atom-editor-sync
  makepkg -si --noconfirm
  cd -
fi

cd ~/.atom
git init
git remote add origin git@github.com:fusion809/atom.git
git pull origin master
git submodule update --init --recursive
cd -
