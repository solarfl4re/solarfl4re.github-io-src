Title: Moving to Pelican and Travis CI
Date: 11/21/15
Modified: 11/23/15
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
script: pelican -s pelicanconf.py
after_success: ./generate.sh deploy
env:
  global:
  - secure: (Encrypted Github key here)
```

I edited the variables in Kevin's [generate.sh](https://github.com/iKevinY/iKevinY.github.io/blob/src/generate.sh) to push to my Github user page's master branch, and all seems to be working: Travis CI builds the site.
Some stupid things I did as I was trying to get it working:
- Didn't build the site before trying to deploy in `.travis.yml`. This resulted in an rsync change_dir error that mentioned the remote directory. But the output directory not existing was the real problem. Facepalm moment.
- Didn't realize that my encrypted Github key would be assigned by Travis CI the variable name I have when encrypting it (doh).

Overall, I'm really happy to have it working. Now I can push a new post from my iPad on the go with [Working Copy](http://workingcopyapp.com) (which I haven't actually gotten yet, but it looks great).
