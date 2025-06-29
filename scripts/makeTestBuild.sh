#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "You must use one argument. Open ${0##*/} in a file editor for more info."
    # First argument: Target 'linux' or 'windows'
	exit
fi

target=$1

TESTDIR=$TESTBUILDPATH
mkdir $TESTDIR

cd $GAMEDIR

chmod u+x ./configure
chmod u+x ./server/configure
chmod u+x ./gameSource/makeEditor.sh

if [[ $target == "linux" ]] ; then
	./configure 1 || exit 1
	cd server
	./configure 1 || exit 1
	cd ..
elif [[ $target == "windows" ]] ; then
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

./gatherData.sh all "$TESTDIR" rsync
./gatherBuildFiles.sh game "$TESTDIR"
./gatherBuildFiles.sh server "$TESTDIR"
./gatherBinaries.sh "$target" all "$TESTDIR"

echo 0 > $TESTDIR/settings/fullscreen.ini
echo 1 > $TESTDIR/settings/useCustomServer.ini
echo localhost > $TESTDIR/settings/CustomServerAddress.ini
echo 8005 > $TESTDIR/settings/customServerPort.ini
echo 1 > $TESTDIR/settings/vogModeOn.ini
echo 1 > $TESTDIR/settings/tutorialDone.ini
echo "USER" > $TESTDIR/settings/email.ini
echo "PASS" > $TESTDIR/settings/password.ini

echo 1 > $TESTDIR/settings/fovEnabled.ini
echo 1 > $TESTDIR/settings/keyboardActions.ini

echo 0 > $TESTDIR/settings/requireTicketServerCheck.ini
echo 1 > $TESTDIR/settings/useTestMap.ini
echo 1 > $TESTDIR/settings/allowVOGMode.ini
echo 1 > $TESTDIR/settings/allowMapRequests.ini
echo "USER" > $TESTDIR/settings/vogAllowAccounts.ini
