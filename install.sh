#!/usr/bin/env bash
set -ex -o pipefail

DOTFILES=(
    .i3
    .inputrc
    .profile
    .vimrc
)

for i in "${DOTFILES[@]}"; do
    ln -sf "$PWD/nomi/$i" "$HOME/$i"
done
