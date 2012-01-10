konjac
======

A Ruby command-line utility for translating files using a YAML wordlist

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
