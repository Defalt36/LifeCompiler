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


latestVersion=$($SCRIPTSDIR/checkoutLastTaggedVersion.sh 2HOL)
if [ -z $latestVersion ] ; then
    echo "Failed to checkout last tagged version. Check if your repositories are correct."
    exit 1
fi

echo -e "\nBuilding 2HOL_v$latestVersion...\n"

cd $GAMEDIR

# Add discord integration
if [ -d $DISCORD_SDK ]; then
	discord_param="\"$MINORDIR\" --discord_sdk_path \"$DISCORD_SDK\""
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

$SCRIPTSDIR/gatherData.sh game "$RELEASEDIR" copy
$SCRIPTSDIR/gatherBuildFiles.sh game "$RELEASEDIR"
$SCRIPTSDIR/gatherBinaries.sh "$target" game "$RELEASEDIR"

echo -e "\nCompressing files...\n"

7z a $RELEASEDIR.zip $RELEASEDIR

echo -e "\nDone building 2HOL v$latestVersion."
