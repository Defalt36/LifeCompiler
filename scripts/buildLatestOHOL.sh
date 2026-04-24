#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "You must use one argument."
    echo "First argument; Target: 'linux' or 'windows'."
	exit
fi

target=$1

if [ $target != 'linux' ] && [ $target != 'windows' ] ; then
    echo "Unknown first argument: $target"
    exit 1
fi

cd $WORKDIR

if [ ! -e minorGems ]
then
	git clone https://github.com/jasonrohrer/minorGems.git	
fi

if [ ! -e OneLife ]
then
	git clone https://github.com/jasonrohrer/OneLife.git
fi

if [ ! -e OneLifeData7 ]
then
	git clone https://github.com/jasonrohrer/OneLifeData7.git	
fi


latestVersion=$($SCRIPTSDIR/checkoutLastTaggedVersion.sh)
echo -e "\nBuilding OHOL_v$latestVersion...\n"

cd $GAMEDIR


chmod u+x ./configure || exit 1
if [ $target == "linux" ] ; then
	./configure 1 || exit 1
elif [ $target == "windows" ] ; then
	./configure 5 || exit 1
fi

cd gameSource
make || exit 1
cd $SCRIPTSDIR

RELEASEDIR="${BUILDSDIR}/OHOL_v${latestVersion}-${target}"
mkdir $RELEASEDIR

echo -e "\nCopying files to ${RELEASEDIR}...\n"

$SCRIPTSDIR/gatherData.sh game "$RELEASEDIR" copy
$SCRIPTSDIR/gatherBuildFiles.sh game "$RELEASEDIR"
$SCRIPTSDIR/gatherBinaries.sh "$target" game "$RELEASEDIR"

echo -e "\nCompressing files...\n"

7z a $RELEASEDIR.zip $RELEASEDIR

echo -e "\nDone building OHOLv$latestVersion."
