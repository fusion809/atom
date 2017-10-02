#!/bin/bash
if ! `which atom > /dev/null 2>&1`; then
    printf "Atom is not installed!"
fi

if ! [[ -d $HOME/.atom/.git ]]; then
    if [[ -d $HOME/.atom ]]; then
         mv $HOME/.atom $HOME/.atom.backup
    fi
    git clone https://github.com/fusion809/atom $HOME/.atom
fi

if ! [[ $PWD == "$HOME/.atom" ]]; then
    cd $HOME/.atom
fi

L=$(cat packages.cson | sed 's/"//g' | sed 's/  //g' | sed 's/packages: \[//g' | sed 's/\]//g' )

apm install package-sync

for i in "${L[$@]}"
do
    apm install $i --no-confirm
done
