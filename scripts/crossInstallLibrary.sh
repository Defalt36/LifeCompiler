#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "You must at least use one argument. Open ${0##*/} in a file editor for more info."
    # First argument: Library 'libpng', 'libz', 'libsdl' or 'libfreetype'
    exit
fi

sdkdisc=false
libz=false
libpng=false
libsdl=false
libfreetype=false

for arg in "$@"; do
    if [[ $arg == "sdkdisc" ]] ; then
        sdkdisc=true
    elif [[ $arg == "libz" ]] ; then
        libz=true
    elif [[ $arg == "libpng" ]] ; then
        libpng=true
    elif [[ $arg == "libsdl" ]] ; then
        libsdl=true
    elif [[ $arg == "libfreetype" ]] ; then
        libfreetype=true
    else
        echo "No supported library called '${arg}'."
        exit 1
    fi
done

build="x86_64-linux-gnu"
host="i686-w64-mingw32"
prefixdir="/usr/i686-w64-mingw32"

# keep the libraries in case you want to uninstall them later
if [ ! -e $LIBRARYDIR ]
then
    mkdir -v $LIBRARYDIR
fi

cd $LIBRARYDIR

if [[ $sdkdisc == "true" ]] ; then
    echo
    echo "Preparing DiscordSDK..."
    
    if [ ! -d discord_game_sdk ]; then
        wget https://dl-game-sdk.discordapp.net/3.2.1/discord_game_sdk.zip
        unzip -d discord_game_sdk discord_game_sdk.zip
        rm discord_game_sdk.zip
    fi
    
    sed -i 's/<Windows.h>/<windows.h>/' ./discord_game_sdk/c/discord_game_sdk.h;
fi

if [[ $libz == "true" ]] ; then
    echo
    echo "Preparing LibZ..."
    
    if [ ! -d zlib-1.2.12 ] ; then
        wget http://zlib.net/fossils/zlib-1.2.12.tar.gz -O- | tar xfz -
    fi
    
    cd zlib-1.2.12 || exit 1
    sudo make -f win32/Makefile.gcc \
        BINARY_PATH=$prefixdir/bin \
        INCLUDE_PATH=$prefixdir/include \
        LIBRARY_PATH=$prefixdir/lib \
        SHARED_MODE=1 \
        PREFIX=$host- \
        install
    cd ..
fi


if [[ $libpng == "true" ]] ; then
    #LibPng won't install propely if Zlib isn't installed fist
    echo
    echo "Preparing LibPNG..."
    
    if [ ! -d libpng-1.6.37 ] ; then
        wget http://downloads.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz -O- | tar xfz -
        # if wget fails try alternative mirror
        if [ $? -ne 0 ]; then
            wget https://github.com/pnggroup/libpng/archive/refs/tags/v1.6.37.tar.gz -O- | tar xfz -
        fi
    fi
    
    cd libpng-1.6.37 || exit 1
    ./configure \
        --host=$host \
        --prefix=$prefixdir \
        CPPFLAGS="-I${prefixdir}/include" \
        LDFLAGS="-L${prefixdir}/lib"
    make
    sudo make install
    cd ..
fi

if [[ $libsdl == "true" ]] ; then
    echo
    echo "Preparing LibSDL..."
    
    if [ ! -d SDL-1.2.15 ] ; then
        wget https://www.libsdl.org/release/SDL-1.2.15.tar.gz -O- | tar xfz -
        # if wget fails try alternative mirror
        if [ $? -ne 0 ]; then
            wget https://github.com/libsdl-org/SDL-1.2/archive/refs/tags/release-1.2.15.tar.gz -O- | tar xfz -
        fi
    fi

    cd SDL-1.2.15 || exit 1
    ./configure \
        --bindir=$prefixdir/bin \
        --libdir=$prefixdir/lib \
        --includedir=$prefixdir/include \
        --host=$host \
        --prefix=$prefixdir \
        CPPFLAGS="-I${prefixdir}/include" \
        LDFLAGS="-L${prefixdir}/lib"
    make
    sudo make install
    cd ..
fi

if [[ $libfreetype == "true" ]] ; then
    echo
    echo "Preparing FreeType2..."
    
    if [ ! -d $LIBRARYDIR/freetype-2.13.2 ] ; then
        wget https://downloads.sourceforge.net/project/freetype/freetype2/2.13.2/freetype-2.13.2.tar.gz -O- | tar xfz -
        # if wget fails try alternative mirror
        if [ $? -ne 0 ]; then
            wget https://download.savannah.gnu.org/releases/freetype/freetype-2.13.2.tar.gz -O- | tar xfz -
        fi
    fi
    
    cd freetype-2.13.2 || exit 1
    ./configure \
        --prefix=$prefixdir \
        --build=$build \
        --host=$host \
        --enable-static \
        CPPFLAGS="-I${prefixdir}/include" \
        LDFLAGS="-L${prefixdir}/lib" \
        PKG_CONFIG_LIBDIR=$prefixdir/lib/pkgconfig
    make
    sudo make install
    cd ..
fi


