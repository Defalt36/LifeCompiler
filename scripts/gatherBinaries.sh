#!/bin/bash

if [ $# -ne 3 ] ; then
	echo "You must use three arguments."
	echo "First argument; Target: 'linux' or 'windows'."
	echo "Second argument; Binaries: 'game', 'editor', 'server' or 'all'."
	echo "Third argument; Destination: '[path]'."
	exit
fi


target=$1
binaries=$2
destination=$3

if [ $target != 'linux' ] && [ $target != 'windows' ] ; then
    echo "Unknown first argument: $target"
    exit 1
elif [ $binaries != 'game' ] && [ $binaries != 'editor' ] && [ $binaries != 'server' ] && [ $binaries != 'all' ] ; then
    echo "Unknown second argument: $binaries"
    exit 1
elif [ ! -d "destination" ] ; then
    echo "Path was not found: $destination"
    exit 1
fi

source=$GAMEDIR

if [ $target == "windows" ] ; then
	cp $GAMEDIR/build/win32/*.dll $destination
    cp $DISCORD_SDK/lib/x86/discord_game_sdk.dll $destination
    #cp /usr/i686-w64-mingw32/bin/*.dll $destination
elif [ $target == "linux" ] ; then
    if [[ ! -f ./discord_game_sdk.so ]]; then
        sudo cp $DISCORD_SDK/lib/x86_64/discord_game_sdk.so $destination
        sudo chmod a+r $destination/discord_game_sdk.so
    fi
fi

if [ $binaries == "game" ] || [ $binaries == "all" ] ; then
    if [ $target == "linux" ] ; then
        cp $source/gameSource/OneLife $destination/OneLife
    elif [ $target == "windows" ] ; then
        cp "$source/gameSource/OneLife.exe" "$destination/OneLife.exe" 2>/dev/null || cp "$source/gameSource/OneLife" "$destination/OneLife.exe"
    fi
fi
if [ $binaries == "editor" ] || [ $binaries == "all" ] ; then
    if [ $target == "linux" ] ; then
        cp $source/gameSource/EditOneLife $destination/EditOneLife
    elif [ $target == "windows" ] ; then
        cp "$source/gameSource/EditOneLife.exe" "$destination/EditOneLife.exe" 2>/dev/null || cp "$source/gameSource/EditOneLife" "$destination/EditOneLife.exe"
    fi
fi
if [ $binaries == "server" ] || [ $binaries == "all" ] ; then
    if [ $target == "linux" ] ; then
        cp $source/server/OneLifeServer $destination/OneLifeServer
    elif [ $target == "windows" ] ; then
        cp "$source/server/OneLifeServer.exe" "$destination/OneLifeServer.exe" 2>/dev/null || cp "$source/server/OneLifeServer" "$destination/OneLifeServer.exe"
    fi
fi
