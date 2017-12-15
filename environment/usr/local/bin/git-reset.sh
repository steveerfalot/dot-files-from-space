echo "PWD: $PWD"
echo "Running git status on git subdirectories"

#find . -type d -depth 4 -exec git --git-dir={}/.git --work-tree=$PWD/{} reset --hard \;
 
find. -type d -depth 4 -exec echo "$(git --git-dir={}/.git --work-tree=$PWD/{} status \;)"



