Konjac
======

A Ruby command-line utility for translating files using a YAML wordlist

Homepage::      http://www.brymck.com
Author::        Bryan McKelvey
Copyright::     (c) 2012 Bryan McKelvey
License::       MIT

Installation
------------

### Stable

With [Ruby](http://www.ruby-lang.org/en/downloads/) installed, run the
following in your terminal:

```bash
gem install konjac
```

### Development

With Ruby, [Git](http://help.github.com/set-up-git-redirect) and
[Bundler](http://gembundler.com/) installed, navigate in your command line to a
directory of your choice, then run:

```bash
git clone git://github.com/brymck/konjac.git
cd konjac
bundle update
rake install
```

Usage
-----

Translate all text files in the current directory from Japanese into English:

```bash
konjac translate *.txt --from japanese --to english
konjac translate *.txt -f ja -t en
```

Use multiple dictionaries:

```bash
konjac translate financial_report_en.txt --to japanese --using {finance,fluffery}
konjac translate financial_report_en.txt -t ja -u {finance,fluffery}
```

Extract text from a .docx? document (creates a plain-text `test.konjac`
file from `test.docx`):

```bash
konjac export test.doc
konjac export test.docx
```

Extract text from a .docx document and process with a dictionary

```bash
konjac export test.docx --from japanese --to english --using pre
konjac export test.docx -f ja -t en -u pre
```

Import tags file back into .docx document (for .doc files, this opens the file
in word and imports the changes; for .docx files this outputs a new file named
`test_imported.docx`):

```bash
konjac import test.doc
konjac import test.docx
```

Add a word to your dictionary:

```bash
konjac add --original dog --from english --translation 犬 --to japanese
konjac add -o dog -f en -r 犬 -t ja
```

Translate a word using your dictionary:

```bash
konjac translate dog --from english --to japanese --word
konjac translate dog -f en -t ja -w
```

Suggest a word using your dictionary:

```bash
konjac suggest dog --from english --to japanese
konjac suggest dog -f en -t ja
```

Dictionary Format
-----------------

Store terms in `~/.konjac/dict.yml`.

_Simple (two-way equivalent terms)_ - English "I" is equivalent to Spanish
"yo":

```yml
-
  en: I
  es: yo
```

_Not as simple_ - Japanese lacks a plural, therefore both "dog" and "dogs"
translate as 犬:

```yml
-
  en: dog
  ja:
  ja: 犬
  en: dogs?
  regex: true  # i.e. the regular expression /dogs?/
```

Extended Example
----------------

~/.konjac/dict.yml:

```yml
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
  regex: true  # i.e. the regular expression /dogs?/
- # Periods
  en:
  en: ". "
  ja: 。
  ja:
  ja: 。
  en: !ruby/regexp '/\.(?:\s|$)/'
- # Spaces between non-ASCII characters
  en:
  en: " "
  ja: !ruby/regexp /\s{2,}/
  ja:
  ja: "\\1\\2"
  en: !ruby/regexp /([^\w])\s([^\w])/
- # Delete extraneous spaces
  en:
  en: ""
  ja: !ruby/regexp /\s(?=[.,:]|$)/
```

~/.konjac/test_en.txt:

```bash
I like dogs.
```

Run

```bash
konjac translate ~/.konjac/test_en.txt --to japanese
```

~/.konjac/test_ja.txt (result):

```bash
僕好き犬。
```

Now, obviously that does require some fiddling to make it more grammatical, but
it's a start (=> `僕は犬が好きだ。`)

Documentation
-------------

Should be simple enough to generate yourself:

```bash
rm -rf konjac
git clone git://github.com/brymck/konjac
cd konjac
bundle update
rake rdoc
rm -rf !(doc)
mv doc/rdoc/* .
rm -rf doc
```

Supplementary Stuff
-------------------

  * [Vim integration](https://github.com/brymck/konjac_vim)
  * [My dictionaries](https://github.com/brymck/konjac_yml)

Name
----

_Hon'yaku_ means "translation" in Japanese. This utility relies on a
**YAM**L wordlist. _Konnyaku_ (Japanese for
"[konjac](http://en.wikipedia.org/wiki/Konjac)") rhymes with _hon'yaku_
and is a type of **yam**. Also,
[Doraemon](http://en.wikipedia.org/wiki/Doraemon) had something called a
_hon'yaku konnyaku_ that allowed him to speak every language. IIRC it
worked with animals too. But I digress.
