#!/usr/bin/env bash

REL=""
VERSION=""
REL_BRANCH=""
NPM_REPOS=(bullhornui bullhornjs montage novo-canvas-ui mosaic coldfusion)

function gmerge() {
  git merge --no-ff ${REL_BRANCH} --no-edit
}

function update_npm_dependencies() {
  local version=$1
  local affected_repos=(montage mosaic coldfusion)

  json -I -f package.json -e "this.version=\"$version\""
  json -f package.json -a -g dependencies | json -a -k | while read repo; do
    if [[ " ${affected_repos[@]} " =~ " $repo " ]]
    then
      echo "*********************** updating $repo *************************"
      json -I -f package.json -e "this.dependencies.$repo=\"$VERSION\""
    fi
  done

  git add package.json
  git commit -m"NOJIRA: update npm versions"
}

function make_latest() {
  json -f package.json -a -g dependencies | json -a -k | while read repo; do
    if [[ " ${NPM_REPOS[@]} " =~ " $repo " ]]
    then
      echo "*********************** making $repo latest *************************"
      json -I -f package.json -e "this.dependencies.$repo=\"latest\""
    fi
  done

  git add package.json
  git commit -m"NOJIRA: make dependencies latest"
  git push
}

function f() {
  REL=$1
  VERSION=$2
  REL_BRANCH="release/$REL"

  prunetags
  git checkout master
  git checkout development
  gp
  git checkout -b ${REL_BRANCH}

  update_npm_dependencies ${VERSION}

  git checkout master
  gmerge
  git tag ${REL}
  git tag ${VERSION}
  git push
  git push --tags
  # backmerge to dev
  git checkout development
  gmerge
  make_latest
  git push
  git branch -d ${REL_BRANCH}
}

#f REL-5070 201802.0.0
