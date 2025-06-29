#!/bin/bash

if [ $# -ne 3 ] ; then
	echo "You must use three arguments. Open ${0##*/} in a file editor for more info."
	# First argument: Target 'game', 'editor', 'server' or 'all'
	# Second argument: Destination
	# Third argument: Mode 'copy', 'symlink', 'rsync'
	exit
fi

# Assets needed for the binaries
common=('categories' 'objects' 'transitions' 'dataVersionNumber.txt')
game=('animations' 'ground' 'music' 'sounds' 'sprites')
editor=('overlays' 'scenes')
server=('faces' 'tutorialMaps')

if [ $1 == "game" ] ; then
	###
	target=( ${common[@]} ${game[@]} )
elif [ $1 == "editor" ] ; then
	###
	target=( ${common[@]} ${game[@]} ${editor[@]} )
elif [ $1 == "server" ] ; then
	###
	target=( ${common[@]} ${server[@]} )
elif [ $1 == "all" ] ; then
	###
	target=( ${common[@]} ${game[@]} ${editor[@]} ${server[@]} )
fi

destination=$2
mode=$3

source=$DATADIR

#clearing cache of data repository
rm -f $source/*/*.fcz

for item in ${target[@]} ; do
	if [[ $mode == "symlink" ]] ; then 
		#Create symlink only
		ln -s "${source}/${item}" "$destination"
	elif [[ $mode == "copy" ]] ; then
		#Copy from repo
		cp -R "${source}/${item}" "$destination"
	elif [[ $mode == "rsync" ]]; then
		rsync -r "${source}/${item}" "$destination"
	fi
done


