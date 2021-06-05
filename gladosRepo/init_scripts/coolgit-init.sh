#this file initilizes a coolgit repository
#$1 is the repo path $2 is the path to the sound files and $3 is an optional argument to
#specifying wheather or not to sym link the sound files

REPO_PATH=$1\.git
START_PATH=$(pwd)
mkdir $REPO_PATH || exit -1
cd $REPO_PATH || exit -1
git init --bare

#make sure we have the shebang if it is not already present
test -f hooks/post-receive || echo \#!/bin/bash > hooks/post-receive 
#create the first lines of the post-recive file to tell it where to find the color_effects file

echo \$COLOR_EFFECTS=$START_PATH/color_effects >> hooks/post-receive
echo \$SOUND_EFFECTS=$2 >> hooks/post-receive
echo \$SOUND_LIBRARY=$START_PATH/sound_manip.sh >> hooks/post-receive

#add our hooks to the post-receive queue
cat $START_PATH/post-receive >> hooks/post-receive

#add a hook to the end of the scripts that we run to make sure that every file we recive can be accessed by all members of the group
#who owns it, the git group
echo chgrp -R git $REPO_PATH 2\>/dev/null >> hooks/post-receive
echo find $REPO_PATH -type d -exec chmod g+rwx {} + 2\>/dev/null >> hooks/post-receive
echo find $REPO_PATH -exec chmod g+rw {} + 2\>/dev/null >> hooks/post-receive

#make sure that all files are owned by the git group
chgrp -R git .
chmod -R g+rwx .
find . -type d -exec chmod g+x '{}' +
