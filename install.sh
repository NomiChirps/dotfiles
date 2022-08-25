#!/usr/bin/env bash
set -e -o pipefail

do_the_thing() {
    # $1 is path to repository dir, "new"
    # $2 is path to corresponding target dir, "old"
    for i in "${DOTFILES[@]}"; do
        old="$2/$i"
        new="$1/$i"
        if [ "$(realpath "$old")" = "$new" ]; then
            # link matches, we already did this one
            echo "'$old' OK"
            continue
        elif [ -e "$old" ]; then
            echo "file exists: $old"
            exit 1
        fi
        # $old does not exist; create a link pointing to $new
        ln -sv "$new" "$old"
    done
}

DOTFILES=(
    .i3
    .inputrc
    .profile
    .vimrc
    .Xmodmap
    .Xresources
)
do_the_thing $PWD/nomi $HOME

DOTFILES=(
    i3status
    udiskie
)
do_the_thing $PWD/dot-config $HOME/.config

