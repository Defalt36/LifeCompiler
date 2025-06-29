#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "You must use one argument. Open ${0##*/} in a file editor for more info."
    # First argument: Target 'linux' or 'windows'
	exit
fi

target=$1

RELEASEDIR="${BUILDSDIR}/${RELEASENAME}_${BUILDSTAMP}"
mkdir $RELEASEDIR

cd $GAMEDIR

chmod u+x ./configure
chmod u+x ./server/configure
chmod u+x ./gameSource/makeEditor.sh

if [ $target == "linux" ] ; then
	./configure 1 || exit 1
    cd server
	.configure 1 || exit 1
    cd ..
elif [ $target == "windows" ] ; then
	./configure 5 || exit 1
	cd server
    ./configure 5 || exit 1
    cd ..
fi

cd gameSource
make || exit 1
./makeEditor.sh || exit 1

cd ../server
make || exit 1

cd $SCRIPTSDIR

echo "Gathering Files..."

./gatherData.sh all "$RELEASEDIR" copy
./gatherBuildFiles.sh game "$RELEASEDIR"
./gatherBuildFiles.sh server "$RELEASEDIR"
./gatherBinaries.sh "$target" all "$RELEASEDIR"

#ln -sf $RELEASEDIR $RELEASENAME

echo "Compressing Files..."

7z a $RELEASEDIR.zip $RELEASEDIR
