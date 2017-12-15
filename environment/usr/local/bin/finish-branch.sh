REL=$1
VERSION=$2

git checkout release/$REL
git pull
git checkout development
git pull
git checkout master
git pull
git merge --no-ff release/$REL
git tag -a $REL -m $REL
git tag -a $VERSION -m $VERSION
git push
git push --tags
git checkout development
git merge --no-ff release/$REL
git push
git push origin :release/$REL
git branch -d release/$REL
