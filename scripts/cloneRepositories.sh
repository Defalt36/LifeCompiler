#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "This script clones the repositories configured in settings.sh. It overrides the currently cloned repositories.\n"
    echo "Procced with cloning:"
    echo -e "\t${REMOTEGAME_USER}/${REMOTEGAME}:${REMOTEGAME_BRANCH}\n\t${REMOTEMINOR_USER}/${REMOTEMINOR}:${REMOTEMINOR_BRANCH}\n\t${REMOTEDATA_USER}/${REMOTEDATA}:${REMOTEDATA_BRANCH}"
    read -rp "Continue? [y/N] " c && [[ $c == [yY] ]] || exit
    echo
fi

cd $WORKDIR

if [ $# -lt 1 ] ; then
    rm -rf $MINORDIR
    rm -rf $GAMEDIR
    rm -rf $DATADIR
	git clone https://github.com/$REMOTEMINOR_USER/$REMOTEMINOR $MINORDIR
    git checkout -b $REMOTEMINOR_BRANCH
	git clone https://github.com/$REMOTEGAME_USER/$REMOTEGAME $GAMEDIR
    git checkout -b $REMOTEGAME_BRANCH
	git clone https://github.com/$REMOTEDATA_USER/$REMOTEDATA $DATADIR
    git checkout -b $REMOTEDATA_BRANCH
else
    user=$1
    if [ ! -e $GAMEDIR ] ; then
        git clone https://github.com/$user/minorGems $MINORDIR
    fi
    if [ ! -e $MINORDIR ] ; then
        git clone https://github.com/$user/OneLife $GAMEDIR
    fi
    if [ ! -e $DATADIR ] ; then
        git clone https://github.com/$user/OneLifeData7 $DATADIR	
    fi
fi


