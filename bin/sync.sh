#!/bin/bash

# cd into the repo root
cd "$(dirname "$0")"
cd ..

set -e

# update
git pull

unset doIt

# bash
rsync -av bash/. ~
source ~/.bash_profile

# git
rsync -av git/. ~

# x
rsync -av x/. ~

# i3wm
if ! [ -e ~/.i3 ]; then
    mkdir ~/.i3
fi
rsync -av i3/. ~/.i3/
