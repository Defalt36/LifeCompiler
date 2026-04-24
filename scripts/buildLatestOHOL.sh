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

$SCRIPTSDIR/cloneRepositories.sh "twohoursonelife"

latestVersion=$($SCRIPTSDIR/checkoutLastTaggedVersion.sh OneLife)
if [ -z $latestVersion ] ; then
    echo "Failed to checkout last tagged version. Check if your repositories are correct."
    exit 1
fi

echo -e "\nBuilding OHOL_v$latestVersion...\n"

cd $GAMEDIR

chmod u+x ./configure || exit 1
if [ $target == "linux" ] ; then
	target=1
elif [ $target == "windows" ] ; then
	target=5
fi

# Add discord integration
if [ -d $DISCORD_SDK ]; then
	./configure $target "$MINORDIR" --discord_sdk_path "$DISCORD_SDK" || exit 1
else
    ./configure $target || exit 1
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

echo -e "\nDone building OHOL_v$latestVersion."
