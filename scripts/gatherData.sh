#!/bin/bash

if [ $# -ne 3 ] ; then
	echo "You must use three arguments. Open ${0##*/} in a file editor for more info."
	echo "First argument; Target: 'game', 'editor', 'server' or 'all'."
	echo "Second argument; Destination: '[path]'."
	echo "Third argument; Mode: 'copy', 'symlink', 'rsync'."
	exit
fi

target=$1
destination=$2
mode=$3

if [ $target != 'game' ] && [ $target != 'editor' ] && [ $target != 'server' ] && [ $target != 'all' ] ; then
    echo "Unknown first argument: $target"
    exit 1
elif [ ! -d "$destination" ] ; then
    echo "Path was not found: $destination"
    exit 1
elif [ $mode != 'copy' ] && [ $mode != 'symlink' ] ; then
    echo "Unknown third argument: $mode"
    exit 1
fi

# Assets needed for the binaries
common=('categories' 'objects' 'transitions' 'dataVersionNumber.txt')
game=('animations' 'ground' 'music' 'sounds' 'sprites')
editor=('overlays' 'scenes')
server=('faces' 'tutorialMaps')

if [ $1 == "game" ] ; then
	###
	targets=( ${common[@]} ${game[@]} )
elif [ $1 == "editor" ] ; then
	###
	targets=( ${common[@]} ${game[@]} ${editor[@]} )
elif [ $1 == "server" ] ; then
	###
	targets=( ${common[@]} ${server[@]} )
elif [ $1 == "all" ] ; then
	###
	targets=( ${common[@]} ${game[@]} ${editor[@]} ${server[@]} )
fi

source=$DATADIR

# remove cache from data repository
find $source -name "*.fcz" -type f -delete

for item in ${targets[@]} ; do
	if [[ $mode == "symlink" ]] ; then 
		#Create symlink only
        if [ -e "$destination/$item" ]; then
            continue
        fi
        if [ -n "$WSL_DISTRO_NAME" ]; then
            cmd.exe /c mklink /J $(wslpath -w "$destination/$item") $(wslpath -w "${source}/${item}")
        else
            ln -s "${source}/${item}" "$destination/$item"
        fi
	elif [[ $mode == "copy" ]] ; then
		#Copy from repo
		cp -R "${source}/${item}" "$destination"
	fi
done


