#!/bin/bash 

SOURCE_DIR=home
pushd $SOURCE_DIR

# Create any directory that doesn't exist first.
for directory in `find . -type d`; do mkdir -pv $HOME/$directory ; done


# TODO
# Currently this leaves an ugly /./ in the middle of the symlink path
# which I don't really love, but it doesn't cause a problem so I can 
# add it to a list of problems to deal with later(never).

for x in `find . -type f`; do  rm -f $HOME/$x && ln -vs `pwd`/$x $HOME/$x; done

