#!/bin/bash

if [ $# -ne 2 ] ; then
	echo "You must use two arguments."
    echo "First argument; Target: 'game' 'editor' or 'server'."
	echo "Second argument; Destination: '[path]'."
	exit
fi

target=$1
destination=$2

if [ $target != 'linux' ] && [ $target != 'windows' ] ; then
    echo "Unknown first argument: $target"
    exit 1
elif [ ! -d "destination" ] ; then
    echo "Unknown second argument: $destination"
    exit 1
fi

source=$GAMEDIR

#cp $source/documentation/Readme.txt $destination/
#cp $source/no_copyright.txt $destination/

### Game Data
if [ $target == "game" ] || [ $target == "editor" ] ; then
    mkdir -p $destination/graphics
    mkdir -p $destination/otherSounds
    mkdir -p $destination/settings
    mkdir -p $destination/languages
    mkdir -p $destination/reverbCache
    mkdir -p $destination/groundTileCache
    mkdir -p $destination/webViewer

    cp $source/gameSource/language.txt $destination/
    cp $source/gameSource/us_english_60.txt $destination/
    cp $source/gameSource/reverbImpulseResponse.aiff $destination/
    cp $source/gameSource/wordList.txt $destination/

    cp $source/gameSource/graphics/* $destination/graphics
    cp $source/gameSource/otherSounds/* $destination/otherSounds
    cp -u $source/gameSource/settings/* $destination/settings
    cp $source/gameSource/languages/* $destination/languages
fi



### Server Data
if [ $target == "server" ] ; then
    mkdir -p $destination/settings
    mkdir -p $destination/webViewer

    cp $source/server/firstNames.txt $destination/
    cp $source/server/kissTest.txt $destination/
    cp $source/server/lastNames.txt $destination/
    cp $source/server/namesInfo.txt $destination/
    cp $source/server/protocol.txt $destination/
    cp $source/server/sampleTestMap.txt $destination/
    cp $source/server/protocol.txt $destination/
    cp $source/server/wordList.txt $destination/

    cp $source/server/webViewer/* $destination/webViewer
    cp -u $source/server/settings/* $destination/settings/

    #cp $source/server/*.sh $destination/
fi

###

rm -f $destination/settings/email.ini
rm -f $destination/settings/accountKey.ini

# remove all editor backup files
find $destination -name "*~" -exec rm -f {} \;

# remove cache from destination
find $destination -name "*.fcz" -type f -delete

