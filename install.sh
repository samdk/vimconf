#!/bin/bash
set -e -u -o pipefail

cd "$(dirname "$0")"

for file in dot*; do
  dotfile="${HOME}/.$(echo "$file" | sed -r 's/^dot//')"

  if [[ -L "$dotfile" ]]; then
    echo "$dotfile is already a symlink, doing nothing"
  else
    if [[ -e "$dotfile" ]]; then
      mv -b "$dotfile" "${dotfile}.old"
    fi

    ln -s "$(pwd)/$file" "$dotfile"
  fi
done

# other setup
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/undo

# -- $HOME/bin --
mkdir -p ~/bin
for script in bin/*; do
  ln -sf "$(pwd)/$script" "${HOME}/$script"
done

