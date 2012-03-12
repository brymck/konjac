---
layout: default
title: Commands
description: Some konjac commands
---

## Translation

{% highlight bash %}
konjac translate source.txt -f ja -t en
{% endhighlight %}

## Extracting Text

{% highlight bash %}
konjac export source.docx
{% endhighlight %}

This will produce a file named source.docx.diff that looks something like the
following:

{% highlight diff %}
--- /path/to/source.docx
+++ /path/to/source.docx
@@ 1 @@
-Paragraph 1
+Paragraph 1
@@ 2 @@
-Paragraph 2
+Paragraph 2
@@ 3 @@
-Paragraph 3
+Paragraph 3
{% endhighlight %}

## Importing Text

{% highlight bash %}
konjac import source.docx
{% endhighlight %}

For example, you could have altered the above .diff file to read:

{% highlight diff %}
--- /path/to/source.docx
+++ /path/to/source.docx
@@ 1 @@
-Paragraph 1
+段落１
@@ 2 @@
-Paragraph 2
+段落２
@@ 3 @@
-Paragraph 3
+段落３
{% endhighlight %}
