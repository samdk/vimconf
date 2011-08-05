#!/bin/bash
rm ~/.vimrc
rm ~/.gvimrc
rm -r ~/.vim

ln -s $(pwd)/dotvim ~/.vim
ln -s $(pwd)/dotvimrc ~/.vimrc

