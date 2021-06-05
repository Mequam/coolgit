#simple script to add a new git user who can use the machines coolgit repos

useradd -m $1
passwd $1
echo "[user]" > /home/$1/.gitconfig
echo "\temail = $2" >> /home/$1/.gitconfig
echo "\tname = $1" >> /home/$1/.gitconfig
usermod -a -G git $1

#purely for the cool sounds, remove if sounds are not necessary
usermod -a -G audio $1
