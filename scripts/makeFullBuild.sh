#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "You must use one argument."
    # First argument: Target 'linux' or 'windows'
    echo "First argument: Target 'linux' or 'windows'"
	exit
fi

target=$1

RELEASEDIR="${BUILDSDIR}/${RELEASENAME}_${BUILDSTAMP}-${target}"
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

echo -e "\nCopying files to ${RELEASEDIR}...\n"

./gatherData.sh all "$RELEASEDIR" copy
./gatherBuildFiles.sh game "$RELEASEDIR"
./gatherBuildFiles.sh server "$RELEASEDIR"
./gatherBinaries.sh "$target" all "$RELEASEDIR"

echo -e "\nCompressing files...\n"

7z a $RELEASEDIR.zip $RELEASEDIR

echo -e "\nDone building."
