#!/bin/sh

if [ $# -ne 1 ] ; then
	exit 1
fi

prefix=$1

cd $MINORDIR || exit 1
git fetch --tags
latestTaggedVersionTag=$(git tag --merged HEAD -l "${prefix}_v*" --sort=-creatordate | head -n 1)
latestTaggedVersion="${latestTaggedVersionTag##*_v}"
if [ -n "$latestTaggedVersionTag" ]; then
    git checkout -q "$latestTaggedVersionTag"
else
    exit 1
fi

cd $GAMEDIR || exit 1
git fetch --tags
latestTaggedVersionATag=$(git tag --merged HEAD -l "${prefix}_v*" --sort=-creatordate | head -n 1)
latestTaggedVersionA="${latestTaggedVersionATag##*_v}"
if [ -n "$latestTaggedVersionATag" ]; then
    git checkout -q "$latestTaggedVersionATag"
else
    exit 1
fi

cd $DATADIR || exit 1
git fetch --tags
latestTaggedVersionBTag=$(git tag --merged HEAD -l "${prefix}_v*" --sort=-creatordate | head -n 1)
latestTaggedVersionB="${latestTaggedVersionBTag##*_v}"
if [ -n "$latestTaggedVersionBTag" ]; then
    git checkout -q "$latestTaggedVersionBTag"
else
    exit 1
fi

latestVersion="$latestTaggedVersionB"

if [ "$latestTaggedVersionA" -gt "$latestTaggedVersionB" ]; then
  latestVersion="$latestTaggedVersionA"
fi

echo $latestVersion
exit 0
