#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "You must use one argument."
    # First argument: Target 'linux' or 'windows'
    echo "First argument: Target 'linux' or 'windows'"
	exit
fi

target=$1

cd $WORKDIR

if [ ! -e minorGems ]
then
	git clone https://github.com/twohoursonelife/minorGems.git	
fi

if [ ! -e OneLife ]
then
	git clone https://github.com/twohoursonelife/OneLife.git
fi

if [ ! -e OneLifeData7 ]
then
	git clone https://github.com/twohoursonelife/OneLifeData7.git	
fi


cd minorGems
git fetch --tags
latestTaggedVersion=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/2HOL_v* | sed -e 's/2HOL_v//'`
git checkout -q 2HOL_v$latestTaggedVersion


cd ../OneLife
git fetch --tags
latestTaggedVersionA=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/2HOL_v* | sed -e 's/2HOL_v//'`
git checkout -q 2HOL_v$latestTaggedVersionA


cd ../OneLifeData7
git fetch --tags
latestTaggedVersionB=`git for-each-ref --sort=-creatordate --format '%(refname:short)' --count=1 refs/tags/2HOL_v* | sed -e 's/2HOL_v//'`
git checkout -q 2HOL_v$latestTaggedVersionB

cd ..

latestVersion=$latestTaggedVersionB
if [ $latestTaggedVersionA -gt $latestTaggedVersionB ]
then
	latestVersion=$latestTaggedVersionA
fi

echo -e "\nBuilding 2HOL_v$latestVersion...\n"

cd $GAMEDIR

# Add discord integration
if [ -d $DISCORD_SDK_PATH ]; then
	discord_param="\"$MINORDIR\" --discord_sdk_path \"$DISCORD_SDK_PATH\""
fi

chmod u+x ./configure || exit 1
if [ $target == "linux" ] ; then
	./configure 1 $discord_param || exit 1
elif [ $target == "windows" ] ; then
	./configure 5 $discord_param || exit 1
fi

cd gameSource
make || exit 1
cd $SCRIPTSDIR

RELEASEDIR="${BUILDSDIR}/2HOL_v${latestVersion}-${target}"
mkdir $RELEASEDIR

echo -e "\nCopying files to ${RELEASEDIR}...\n"

$ASSISTANTDIR/scripts/gatherData.sh game "$RELEASEDIR" copy
$ASSISTANTDIR/scripts/gatherBuildFiles.sh game "$RELEASEDIR"
$ASSISTANTDIR/scripts/gatherBinaries.sh "$target" game "$RELEASEDIR"

echo -e "\nCompressing files...\n"

7z a $RELEASEDIR.zip $RELEASEDIR

echo -e "\nDone building 2HOL v$latestVersion."
