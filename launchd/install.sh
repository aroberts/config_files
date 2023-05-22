#!/bin/bash

# make sure we're installing from the right directory
cd `dirname $0`

for name in LaunchAgents/*; do
  plist=`basename $name`
  target="$HOME/Library/$name"

  if [[ ! `grep "^$name$" $PWD/do_not_install` ]]; then
    # test
    echo "$target"
    # echo "$PWD/$name $target"
    # echo $plist

    if [ -f "$target" ]; then
      launchctl unload "$target"
    fi

    cp "$PWD/$name" "$target"
    launchctl load "$target"
  fi
done


for name in LaunchDaemons/*; do
  plist=`basename $name`
  target="/Library/$name"

  if [[ ! `grep "^$name$" $PWD/do_not_install` ]]; then
    # test
    echo "$target"
    # echo "$PWD/$name $target"
    # echo $plist

    if [ -f "$target" ]; then
      sudo launchctl unload "$target"
    fi

    sudo cp "$PWD/$name" "$target"
    sudo launchctl load "$target"
  fi
done


