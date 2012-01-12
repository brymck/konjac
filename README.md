konjac
======

A Ruby command-line utility for translating files using a YAML wordlist

**Homepage**: http://brymck.herokuapp.com
**Author**: Bryan McKelvey
**Copyright**: (c) 2012 Bryan McKelvey
**License**: MIT

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

Dictionary Format
-----------------

Store terms in `~/.konjac/dict.yml`.

**Simple (two-way equivalent terms)** - English "I" is equivalent to Spanish
"yo":

    -
      en: I
      es: yo

**Not as simple** - Japanese lacks a plural, therefore both "dog" and "dogs"
translate as 犬:

    -
      en: dog
      ja:
        ja: 犬
        en: dogs?  # i.e. the regular expression /dogs?/

Usage
-----

Translate all text files in the current directory from Japanese into English:

    konjac translate *.txt from japanese to english

Utilize a document's implied language (English) and translate into Japanese:

    konjac translate test_en.txt into japanese


Extended Example
----------------

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
