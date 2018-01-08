#!/usr/bin/env bash
# arg1 (REQUIRED) string - release ticket number
# arg2 (REQUIRED) string - version of software
# arg3 (optional) boolean - if passed in not push any changes
# arg4 (optional) boolean - if passed in will rebase the current branch from development

if [ -z $1 ] || [ -z $2 ];
then
  echo "Must pass in the REL ticket number and the version of the software"
  echo "./cut-branches.sh REL-1234 2018.01.0"
  exit 1
fi

REL=$1
VERSION=$2
dryrun=$3
rebase=$4

BASE_DIR=/workspace/bh-env

REPOS=(CFusionMX7 montage mosaic caldera okemo core-services)
#REPOS=(mosaic)

for i in ${REPOS[@]}; do
	cd ${BASE_DIR}/${i}
	git checkout development
	git up
	if ${rebase}; then
		git checkout release/${REL}
		git rebase development
		git push
	else
		git checkout -b release/${REL}
		if [ -f package.json ]; then
			json -I -f package.json -e "this.version=\"$VERSION\""
			git add package.json
			git commit -nm"NOJIRA: update version number"
		fi
	fi
  git checkout master
  git merge --no-ff release/${REL} --no-edit
  git push
  git fetch --prune origin +refs/tags/*:refs/tags/*
  git fetch -t
  git tag -a ${VERSION} -m "$VERSION"
  git tag -a ${REL} -m "$REL"
  #git push --tags
  #git push origin :release/$REL
done
