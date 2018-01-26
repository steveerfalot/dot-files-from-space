#!/usr/bin/env bash

function update_npm_dependencies() {
  local VERSION=$1

  local npm_repos=(bullhornui bullhornjs bullhornCSS montage novo-canvas-ui mosaic coldfusion)
  local affected_repos=(montage mosaic coldfusion)

  json -I -f package.json -e "this.version=\"$VERSION\""
  json -f package.json -a -g dependencies | json -a -k | while read repo; do
    if [[ " ${affected_repos[@]} " =~ " $repo " ]]
    then
      echo "*********************** updating $repo *************************"
      json -I -f package.json -e "this.dependencies.$repo=\"$VERSION\""
    fi
  done

  git add package.json
  git commit -m"NOJIRA: update npm versions"
  git push
}

function f() {
  local rel=$1
  local version=$2
  local rel_branch="release/$rel"

  prunetags
  git checkout master
  git checkout development
  gp
  git checkout -b ${rel_branch}

  update_npm_dependencies ${version}

  git checkout master
  git merge --no-ff ${rel_branch} --no-edit
  git tag ${rel_branch}
  git tag ${version}
  git push
  git push --tags
  # backmerge to dev
  git checkout development
  git merge --no-ff ${rel_branch} --no-edit
  git push
  git branch -d ${rel_branch}
}

#f REL-5070 201802.0.0
