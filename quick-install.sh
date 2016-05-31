#!/bin/bash
L=$(cat packages.cson | sed 's/"//g' | sed 's/  //g' | sed 's/packages: \[//g' | sed 's/\]//g' | sed "s/\n/ /g")
for i in "${L[@]}"
do
  apm install $i --no-confirm
done

apm install https://github.com/fusion809/language-patch2 \
  https://github.com/fusion809/language-ini2 \
  https://github.com/fusion809/browser-plus-fix
