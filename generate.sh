#!/usr/bin/env bash

usage="Usage: $(basename "$0") (deploy | diff | serve)

Commands:
  deploy     Upload site to Github Pages
  diff       Compare locally generated site to live site
  serve      Generate and serve site (auto-reloads on changes)"

TARGET_REPO="solarfl4re/solarfl4re.github.io"
GH_PAGES_BRANCH="master"

DEVELOP_CONF="pelicanconf.py"
PUBLISH_CONF="publishconf.py"

OUTPUT_DIR="output"
REMOTE_DIR="remote"

PY_CMD="python3"
SERVER="http.server"
PORT="8000"

rootPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

generate_site() {
  # Based on http://zonca.github.io/2013/09/automatically-build-pelican-and-publish-to-github-pages.html
  if [ "$TRAVIS" == "true" ]; then
    # Ensure that builds triggered by pull requests are not deployed
    if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
      echo "Successfully built pull request #$TRAVIS_PULL_REQUEST."
      exit 0
    fi

    echo "Deploying site to $GH_PAGES_BRANCH branch of $TARGET_REPO."
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
  else
    cd "$rootPath" || exit 1
    pelican -s $PUBLISH_CONF
  fi

  # Pull hash and commit message of the most recent commit
  commitHash=$(git rev-parse HEAD)
  commitMessage=$(git log -1 --pretty=%B)

  # Clone the GitHub Pages branch and rsync it with the newly generated files
  GITHUB_REPO=https://${GH_TOKEN:-git}@github.com/${TARGET_REPO}.git
  git clone --branch $GH_PAGES_BRANCH --depth 1 "$GITHUB_REPO" $REMOTE_DIR
  rsync -r --exclude=.git --delete "$OUTPUT_DIR/" "$REMOTE_DIR/"
  pushd $REMOTE_DIR > /dev/null

  git add -A
  git status -s

  $1  # execute the function that was passed as an argument

  popd > /dev/null
  rm -rf -- $REMOTE_DIR $OUTPUT_DIR && echo "Removed $REMOTE_DIR and $OUTPUT_DIR."
}

push_changes() {
  if [ "$TRAVIS" == "true" ]; then
    longMessage="Generated by $commitHash; pushed by build #$TRAVIS_BUILD_NUMBER."
    git commit -m "$commitMessage" -m "$longMessage"
    git push origin $GH_PAGES_BRANCH
  else
    read -rp "Push changes to GitHub Pages? [y/N] " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      git commit -m "$commitMessage" -m "Generated by $commitHash."
      git push origin $GH_PAGES_BRANCH
    fi
  fi
}

case "$1" in
  'deploy')
    generate_site push_changes
    ;;

  'diff')
    generate_site 'git --no-pager diff --cached --color-words'
    ;;

  'serve')
    developPath=${rootPath}/develop
    local_ip=$(ifconfig | grep 'inet ' | awk 'NR==2 {print $2}')

    # Seed directory with site content
    cd "$rootPath" && pelican -s $DEVELOP_CONF > /dev/null
    echo "Serving HTTP at $(tput bold)${local_ip}:${PORT}$(tput sgr0)."

    cleanup() {
      pkill -f $SERVER
      cd "$rootPath" && rm -r "$developPath" && echo && exit 0
    }

    trap cleanup SIGINT

    (pelican -rs $DEVELOP_CONF 2> /dev/null) &
    (cd "$developPath" || exit 1; $PY_CMD -m $SERVER $PORT 1> /dev/null) &
    wait
    ;;

  *)
    echo "$usage"
    exit 2
    ;;

esac
