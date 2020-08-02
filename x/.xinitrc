#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# backlight
xbacklight -set 12

# fcitx
fcitx &

# network manager
nm-applet --no-agent &

# read .Xresources file
xrdb -merge ~/.Xresources &

# start i3wm
exec i3
