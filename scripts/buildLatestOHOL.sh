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


cd minorGems
git fetch --tags
latestTaggedVersion=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
git checkout -q OneLife_v$latestTaggedVersion


cd ../OneLife
git fetch --tags
latestTaggedVersionA=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
git checkout -q OneLife_v$latestTaggedVersionA


cd ../OneLifeData7
git fetch --tags
latestTaggedVersionB=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/OneLife_v* | sed -e 's/OneLife_v//'`
git checkout -q OneLife_v$latestTaggedVersionB

cd ..

latestVersion=$latestTaggedVersionB
if [ $latestTaggedVersionA -gt $latestTaggedVersionB ]
then
	latestVersion=$latestTaggedVersionA
fi

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

$ASSISTANTDIR/scripts/gatherData.sh game "$RELEASEDIR" copy
$ASSISTANTDIR/scripts/gatherBuildFiles.sh game "$RELEASEDIR"
$ASSISTANTDIR/scripts/gatherBinaries.sh "$target" game "$RELEASEDIR"

echo -e "\nCompressing files...\n"

7z a $RELEASEDIR.zip $RELEASEDIR

echo -e "\nDone building OHOLv$latestVersion."
