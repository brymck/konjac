---
layout: default
title: Installation
description: Installing konjac
---

Konjac is currently only available for Mac OS X. There are plans to port
everything to Windows, but work hasn't yet started.

Mac
---

konjac has the following requirements:

 1. Office for Mac
 2. [Git](http://git-scm.com/)
 3. Xcode
 4. [Ruby](http://www.ruby-lang.org/)

If you've already installed Ruby by compiling from source via RVM, this guide
is probably unnecessary. Just run `gem install konjac` and you're done.

For Xcode, I recommend that you use version 4.2.x or earlier. 4.3+ has much of
the additional functionality that konjac depends on relegated to downloadable
extras. A full install may require signing up for the Apple Developer program
(free) and downloading from
[here](https://developer.apple.com/downloads/index.action?name=xcode%204.2.1%20for%20lion).

To make sure Ruby is linked to the right compilers, run the following in a terminal:

{% highlight bash %}
sudo ln -s /usr/bin/llvm-gcc-4.2 /usr/bin/gcc-4.2
{% endhighlight %}

For Ruby, version 1.9.2+ is necessary. I recommend RVM (Ruby Version Manager) to
handle installations of Ruby. The following bash script should suffice:

{% highlight bash %}
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
source ~/.bash_profile
rvm install 1.9.3
rvm use 1.9.3 --default
{% endhighlight %}

Once you have Xcode and Ruby installed, run the following in a terminal:

{% highlight bash %}
gem install konjac
{% endhighlight %}
