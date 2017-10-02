#!/bin/bash
if ! `which atom > /dev/null 2>&1`; then
  printf "Atom is not installed!"
fi

L=$(cat packages.cson | sed 's/"//g' | sed 's/  //g' | sed 's/packages: \[//g' | sed 's/\]//g' )

apm install package-sync

for i in "${L[$@]}"
do
  apm install $i --no-confirm
done
