#!/bin/bash
rm ~/.vimrc
rm ~/.gvimrc
rm -r ~/.vim

cp -r dotvim ~/.vim
cp dotvimrc ~/.vimrc

