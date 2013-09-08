#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# backlight
xbacklight -set 30

#export LANG=zh_CN.UTF-8
#export LC_ALL="zh_CN.UTF-8"

# emacs server
LC_CTYPE=zh_CN.UTF-8 emacs --daemon

# fcitx
fcitx &

# read .Xresources file
xrdb -merge /home/darkjh/.Xresources &

# launch powerline server
java -Xmx50m -cp ~/projects/scala/powerline-shell-scala/target/scala-2.9.2/powerline-shell-scala-assembly-0.1.0-SNAPSHOT.jar PowerlineServer

# goagent for GFW
# python2 /home/darkjh/python/goagent/local/proxy.py &

# start i3wm
exec i3
