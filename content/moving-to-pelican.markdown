Title: Moving to Pelican and Travis CI
Date: 11/21/15
Modified: 12/1/15 1:07
Category: Blog
Tags: pelican, travis cl
Author: David Lane

I now build the site with Pelican instead of Hakyll, because I know Python better than Haskell, and Pelican has a larger community and is simple to get going.
I followed instructions from [Kevin Yap](http://kevinyap.ca/2014/06/deploying-pelican-sites-using-travis-ci) to set up Travis CI. My `.travis.yml` file looks like so:
```
language: python
python:
- '3.5'
install: pip install -r requirements.txt
before-script:
- git submodule init
- git submodule update
script: pelican -s pelicanconf.py
after_success: ./generate.sh deploy
env:
  global:
  - secure: (Encrypted Github key here)
```

I edited the variables in Kevin's [generate.sh](https://github.com/iKevinY/iKevinY.github.io/blob/src/generate.sh) to push to my Github user page's master branch, and all seems to be working: Travis CI builds the site when I push new commits.
Some problems I encountered:

- Didn't build the site before trying to deploy in `.travis.yml`. This resulted in an rsync `change_dir` "Directory not found" error that mentioned the remote directory. The real problem was that there was no output directory for rsync to copy!
- Tried to assign my encrypted Github key a variable name in my Travis config. This didn't work, because the encrypted key had the name I gave it when running `travis encrypt`; it just wasn't visible.

Although it took a few hours to set up, I'm really happy to have it working. Now I can push a new post from my iPad on the go with [Working Copy](http://workingcopyapp.com), which is easy to use and totally worth the money I spent.
