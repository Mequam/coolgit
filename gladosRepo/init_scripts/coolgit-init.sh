#this file initilizes a coolgit repository
#$1 is the repo path $2 is the path to the sound files and $3 is an optional argument to
#specifying wheather or not to sym link the sound files

REPO_PATH=$1\.git
START_PATH=$(pwd)
mkdir $REPO_PATH || exit -1
cd $REPO_PATH || exit -1
git init --bare

#add our hooks to the post-receive queue
cat $START_PATH/post-receive >> hooks/post-receive

if [ $3 = "-ln" ]
then
	#if we are using sym links to an alternative location for storage
	ln $2 hooks/sounds
	
	#used by the post-recive file
	ln color_effect hooks/color_effect
else
	#just copy the file as is (well with the name sounds)
	mkdir hooks/sounds
	cp -r $2/* hooks/sounds
	
	#used by the post-recive file
	cp color_effect hooks/color_effect
fi

#add a hook to the end of the scripts that we run to make sure that every file we recive can be accessed by all members of the group
#who owns it, the git group
echo chgrp -R git $REPO_PATH 2\>/dev/null >> hooks/post-receive
echo find $REPO_PATH -type d -exec chmod g+rwx {} + 2\>/dev/null >> hooks/post-receive
echo find $REPO_PATH -exec chmod g+rw {} + 2\>/dev/null >> hooks/post-receive

#make sure that all files are owned by the git group
chgrp -R git .
chmod -R g+rwx .
find . -type d -exec chmod g+x '{}' +
