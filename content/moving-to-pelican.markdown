Title: Moving to Pelican and Travis CI
Date: 11/21/15
Category: Blog
Tags: pelican, travis cl
Author: David Lane

I now build the site with Pelican instead of Hakyll, primarily because a) I know Python, and b) Pelican has a larger community and is simple to get going.
I followed instructions from [Kevin Yap](http://kevinyap.ca/2014/06/deploying-pelican-sites-using-travis-ci) to set up Travis CI. My `.travis.yml` file looks like so:
```
language: python
python:
- '3.5'
install: pip install -r requirements.txt
before-script:
- git submodule init
- git submodule update
script: ./generate.sh deploy
env:
  global:
  - secure: (Encrypted github key here)
```

I edited Kevin's [generate.sh](https://github.com/iKevinY/iKevinY.github.io/blob/src/generate.sh) to push to my Github user page's master branch. Hopefully it works...
