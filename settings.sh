#!/bin/bash

export ASSISTANTDIR=$START_DIR
export SCRIPTSDIR=$ASSISTANTDIR/scripts
export WORKDIR=$ASSISTANTDIR/..

export GAMEDIR=$WORKDIR/OneLife
export MINORDIR=$WORKDIR/minorGems 
export DATADIR=$WORKDIR/OneLifeData7


export TIMESTAMP=$(date '+(%F,%H%M)')
export RELEASENAME=OneLife
export TARGETSYSTEM=windows

export REMOTEGAME=OneLife
export REMOTEGAME_USER=twohoursonelife
export REMOTEGAME_BRANCH=master

export REMOTEMINOR=minorGems
export REMOTEMINOR_USER=twohoursonelife
export REMOTEMINOR_BRANCH=master

export REMOTEDATA=OneLifeData7
export REMOTEDATA_USER=twohoursonelife
export REMOTEDATA_BRANCH=master

export BUILDSDIR=$WORKDIR/builds
export LIBRARYDIR=$WORKDIR/libraries

export TESTBUILDFOLDER=$BUILDSDIR
export TESTBUILDNAME=XLife_test

if [ ! -d $BUILDSDIR ] ; then
    mkdir $BUILDSDIR
fi

if [ ! -d $LIBRARYDIR ] ; then
    mkdir $LIBRARYDIR
fi

if [ $TARGETSYSTEM == "windows" ] ; then
    if [[ ! ":$PATH:" == *"/usr/i686-w64-mingw32/bin:"* ]]; then
        #export PATH="/usr/i686-w64-mingw32/bin:${PATH}"
        echo -e "\n# add mingw32 binaries to path" >> ~/.bashrc
        echo 'export PATH="/usr/i686-w64-mingw32/bin:${PATH}"' >> ~/.bashrc
        source ~/.bashrc
    fi
fi
