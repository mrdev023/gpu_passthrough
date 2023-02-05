#!/bin/bash

# Install dotfiles
rm -rf "$HOME/.config/kvm"
ln -s "$(pwd)/dotfiles/kvm" "$HOME/.config/kvm"
echo "Symbolic link created : $(pwd)/dotfiles/kvm -> $HOME/.config/kvm"
