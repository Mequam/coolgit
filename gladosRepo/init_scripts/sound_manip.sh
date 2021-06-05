#this file is used to read barks from a bark repositiory (or file) with two subfiles named read and unread
#the idea is that we chain get bark into play bark on get bark sucess and reset barks on get_bark failure 

#this function gets a bark from the given sound set that HAS NOT YET BEEN PLAYED
#if no such bark exists the get_bark function fails
get_bark () {
	bark=$(ls $1/unread | tr '\n' ' ' | awk {'print $1'})
	
	#-n test for a non empty string
	if [ -n "$bark" ]
	then
		echo $bark
		return 0
	fi
		return 1
}

#this function plays the given bark inside of the given sound set and moves it to read
play_bark () {
	cat $1/unread/$2 | aplay && mv $1/unread/$2 $1/read/$2 || return 1
}

#this function resets the given bark set to all unread
reset_barks() {
	mv $1/read/* $1/unread/
}
