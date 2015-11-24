#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'David'
SITENAME = '0x38B - Thoughts on language learning and more'
SITEURL = 'http://0x38b.com'

PATH = 'content'
STATIC_PATHS = ['images', 'extra/CNAME']
EXTRA_PATH_METADATA = {'extra/CNAME': {'path': 'CNAME'},}

TIMEZONE = 'America/Anchorage'

DEFAULT_LANG = 'en'
THEME = 'themes/blue-penguin'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# MENUITEMS = (
#     ('About', 'https://github.com/'),
#     ('Linux Kernel', 'https://www.kernel.org/'),
# )

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)
DISQUS_SITENAME = '0x38b'

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
