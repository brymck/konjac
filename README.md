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

### Languages

All languages for use within a particular dictionary file file must be described

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


Example
-------

~/.konjac/dict.yml:

    -
      en: I
      ja: 僕
    -
      en: like
      ja: 好き
    -
      en:
        en: dog
        ja: 犬
      ja:
        ja: 犬
        en: dogs?
    - # Periods
      en:
        en: ". "
        ja: 。
      ja:
        ja: 。
        en: !ruby/regexp '/\.\s?/'
    - # Spaces between non-ASCII characters
      en:
        en: " "
        ja: !ruby/regexp '/\s{2,}/'
      ja:
        ja: "\\1\\2"
        en: !ruby/regexp '/([^a-z])\s([^a-z])/'

~/.konjac/test_en.txt

    I like dogs.

Run

    konjac translate ~/.konjac/test_en.txt into japanese

~/.konjac/test_ja.txt (result):

    僕好き犬。

Now, obviously that does require some fiddling to make it more grammatical, but
it's a start (=> `僕は犬が好きだ。`)

Name
----

*Hon'yaku* means "translation" in Japanese. This utility relies on a YAML
wordlist. *Konnyaku* (Japanese for "konjac") rhymes with *hon'yaku* and is a
type of yam. Also, Doraemon had something called a *hon'yaku konnyaku* that
allowed one to listen to animals. But I digress.
