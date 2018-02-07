#!/usr/bin/env bash

function gpull() {
#
#  find . -name .git -type d -prune | while read d; do
#   cd $d/..
#   echo "$PWD >" git reset --hard
#   cd $OLDPWD
#  done

  find . -type d \( -exec /usr/bin/test -d "{}/.git" -a "{}" != "." \; -print -prune -o -name .git -prune \) | while read d; do
    cd ${d}
    git remote prune origin
    git stash && git pull && git stash pop
    cd -
  done

  #find . -depth -type d -exec git --git-dir={}/.git --work-tree=$PWD/{} reset --hard \;

  #find . -type d -depth 4 -exec echo "$(git --git-dir={}/.git --work-tree=$PWD/{} status \;)"

}



