REL=$1
VERSION=$2
rebase=$3

BASE_DIR=/workspace/bh-env

REPOS=(CFusionMX7 montage mosaic caldera okemo core-services)
#REPOS=(mosaic)

for i in ${REPOS[@]}; do
	cd $BASE_DIR/${i}
	git checkout development
	git up
	if $rebase; then
		git checkout release/$REL
		git rebase development
		git push
	else
		git checkout -b release/$REL
		if [ -f package.json ]; then
			json -I -f package.json -e "this.version=\"$VERSION\""
			git add package.json
			git commit -nm"NOJIRA: update version number"
		fi
	fi
  git checkout master
  git merge --no-ff release/$REL --no-edit
  git push
  git fetch --prune origin +refs/tags/*:refs/tags/*
  git fetch -t
  git tag -a $VERSION -m "$VERSION"
  git tag -a $REL -m "$REL"
  #git push --tags
  #git push origin :release/$REL
done
