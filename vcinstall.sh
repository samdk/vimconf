#!/bin/bash

# installs everything. existing files are moved out of the way,
# and replaced with symbolic links to the files in this repo.
# this makes it easy to keep things up to date and synced
# between machines, since any edits happen in the gitted files.

# back up existing files
[[ -e ~/.vimrc     ]] && mv -b ~/.vimrc{,.old}
[[ -e ~/.gvimrc    ]] && mv -b ~/.gvimrc{,.old}
[[ -e ~/.vim       ]] && mv -b ~/.vim{,.old}
[[ -e ~/.bashrc    ]] && mv -b ~/.bashrc{,.old}
[[ -e ~/.gitconfig ]] && mv -b ~/.gitconfig{,.old}

# -- vim --
ln -s $(pwd)/dotvim ~/.vim
ln -s $(pwd)/dotvimrc ~/.vimrc
  # these are not part of the repo
  mkdir -p ~/.vim/backup
  mkdir -p ~/.vim/tmp
  mkdir -p ~/.vim/undo

# -- bashrc --
ln -s $(pwd)/dotbashrc ~/.bashrc

# -- $HOME/bin --
mkdir -p ~/bin
for script in bin/*; do
  ln -s $(pwd)/$script ~/$script
done

# -- gitconfig --
ln -s $(pwd)/dotgitconfig ~/.gitconfig

