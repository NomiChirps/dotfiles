#!/usr/bin/env bash
set -e -o pipefail

DOTFILES=(
    .i3
    .inputrc
    .profile
    .vimrc
    .Xmodmap
    .Xresources
)

for i in "${DOTFILES[@]}"; do
    old="$HOME/$i"
    new="$PWD/nomi/$i"
    if [ -d "$old" -a ! -h "$old" ]; then
        echo "$old is a directory; check and remove it manually first."
        exit 1
    fi
    if [ -f "$old" ] && ! diff -u "$old" "$new"; then
        echo "$old exists with different contents; refusing to overwrite."
        exit 1
    fi
    if [ "$(realpath "$old")" = "$new" ]; then
        # link matches
        echo "'$old' OK"
        continue
    fi
    if [ -d "$new" -a -h "$old" ]; then
        # directory already symlinked, but elsewhere
        echo "$old exists with different contents; refusing to overwrite."
        exit 1
    fi
    # destination either doesn't exist, or is a regular file with the same contents as the source. replace it.
    cp -sfv "$PWD/nomi/$i" "$HOME/$i"
done
