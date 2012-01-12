konjac
======

A Ruby command-line utility for translating files using a YAML wordlist

Installation
------------

### Stable

With [Ruby](http://www.ruby-lang.org/en/downloads/) installed, run the
following in your terminal:

    gem install konjac

### Development

With Ruby and [Git](http://help.github.com/set-up-git-redirect) installed,
navigate in your command line to a directory of your choice, then run:

    git clone git://github.com/brymck/konjac.git
    cd konjac
    rake install

Usage
-----

Create a file in `~/.konjac/` called `dict.yml`. The file should have the
following format:

    languages:
      en:
        - english
        - eng
      ja:
        - japanese
        - jpn

    ...

    terms:
      -
        en: japanese
        ja: nihongo
      -
        en: book
        ja: hon

You can then translate a file using the command line like so:

    konjac translate *.txt from japanese to english

Name
----

*Hon'yaku* means "translation" in Japanese. This utility relies on a YAML
wordlist. *Konnyaku* (Japanese for "konjac") rhymes with *hon'yaku* and is a
type of yam. Also, Doraemon had something called a *hon'yaku konnyaku* that
allowed one to listen to animals. But I digress.
