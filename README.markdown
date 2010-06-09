# Summary
VimConf is my `.vim` and `.vimrc`. `vcinstall` is a very simple bash script that removes the current `~/.vim`, `~/.vimrc`, and `~/.gvimrc` and copies dotvim and dotvimrc to `~/.vim` and `~/.vimrc`. Don't run it unless you want your current Vim configuration to be completely overwritten.

# Details
`.vim` includes a custom color scheme, and a slightly modified version of the  default python.vim syntax highlighting file that adds support for coloring class names differently than function names. It also includes the directories backup and tmp, which are used for Vim's backup/swap files so they don't clutter up working directories.

`.vimrc` sets configuration options for both Vim and GVim/MacVim. I recommend you take a look at the settings and tweak them to your liking. (Most settings are commented.) If you don't have the default font (Inconsolata) enabled, things may not look very good at first. Inconsolata can be downloaded from `http://www.levien.com/type/myfonts/inconsolata.html` and if you're using Linux is very likely also in the package manager. Font size is set for an expected display font resolution of 96dpi. If you're using something different you may want to tweak it.

# Credits
My `.vimrc` is based largely on those of other people around the internet, most especially in a few threads on Hacker News. If you've ever posted a `.vimrc` online, thanks!

My color scheme is inspired by/based on Obsidian, a color scheme that ships with Notepad++ and (a little bit) on the wombat theme for Vim.

My modified `python.vim` is based on the default `python.vim` files that ships with GVim on Fedora.

