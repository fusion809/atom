#!/bin/bash
L=$(cat packages.cson | sed 's/"//g' | sed 's/  //g' | sed 's/packages: \[//g' | sed 's/\]//g' )
for i in "${L[$@]}"
do
  apm install $i --no-confirm
done

apm install fusion809/language-patch2 fusion809/language-ini2
