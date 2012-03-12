---
layout: default
title: Vim
description: How to use konjac for translation
---

## Installation

You can grab the latest release
[here](https://github.com/b4winckler/macvim/downloads). You can follow the instructions
in the readme, although I generally just run the following:

{% highlight bash %}
cd ~/Downloads
tar xzf MacVim-snapshot-*.tbz
cd MacVim-snapshot-*
sudo cp -r MacVim.app /Applications && sudo cp mvim /usr/bin
{% endhighlight %}

If you have Homebrew, you can try

{% highlight bash %}
brew install macvim
{% endhighlight %}

## Getting Started

Teaching Vim is beyond the scope of these help pages. If you're interesting in
trying Vim out, I recommend making a copy of the tutorial file and then opening
it in MacVim via the following:

{% highlight bash %}
vim -c "e $VIMRUNTIME/tutor/tutor" -c "w! TUTORCOPY" -c "q"
mvim TUTORCOPY
{% endhighlight %}

Some other resources:

  * [Vimcasts](http://vimcasts.org/)
  * [Graphical vi-vim Cheat Sheet](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html)
  * [vim.org's Vim Book](ftp://ftp.vim.org/pub/vim/doc/book/vimbook-OPL.pdf)

## Preferences

If you're not sure where to get started, you can always borrow [my
preferences](https://github.com/brymck/dotvim):

{% highlight bash %}
cd ~
rm -rf .vim
git clone http://github.com/brymck/dotvim.git .vim
rm .vimrc
ln -s .vim/vimrc .vimrc
cd .vim
git submodule init
git submodule update
mkdir autoload
cd autoload
ln -s ../pathogen/autoload/pathogen.vim pathogen.vim
{% endhighlight %}
