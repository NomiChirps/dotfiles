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
        elif [ -L "old" ]; then
            echo "symbolic link exists: $old"
            exit 1
        elif [ -f "$old" ]; then
            if diff -u "$old" "$new"; then
                # old file exists with same contents
                ln -svf "$new" "$old"
                continue
            fi
            # old file exists but with different contents
            read -p "Apply changes? [y/N]: "
            if [ "$REPLY" = "y" ]; then
                ln -svf "$new" "$old"
                continue
            fi
        elif [ -e "$old" ]; then
            echo "not a regular file: $old"
            exit 1
        else
            # old file doesn't exist
            ln -sv "$new" "$old"
        fi
    done
}

DOTFILES=(
    .inputrc
    .profile
    .vimrc
    .gitconfig
    .git-hooks
)
do_the_thing $PWD/nomi $HOME

DOTFILES=(
    xfce4/terminal/terminalrc
    xfce4/xfconf/xfce-perchannel-xml/accessibility.xml
    xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
    xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
)
do_the_thing $PWD/dot-config $HOME/.config

