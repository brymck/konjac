{% capture page_url %}{{ page.url | remove_first: "/" }}{% endcapture %}
{% for link in site.nav %}
  {% if page_url == link.url or (page_url == "index.html" and link.url == "") %}
  * {{ link.text }}
  {% else %}
  * [{{ link.text }}](/konjac/{{ link.url }})
  {% endif %}
{% endfor %}
  * [Source](https://github.com/brymck/konjac/)
