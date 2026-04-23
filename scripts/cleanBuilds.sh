#!/bin/sh

for directory in $GAMEDIR $MINORDIR $SERVERDIR ; do
    find $directory -type f -name '*.o' -exec rm -vf {} +
    find $directory -type f -name '*.dep' -exec rm -vf {} +
    find $directory -type f -name '*.dep2' -exec rm -vf {} +
done