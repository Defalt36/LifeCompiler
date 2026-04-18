#!/bin/sh

### To avoid installing something you do not want run the commands manually

cd $WORKDIR

sudo apt-get --assume-yes update
sudo apt-get --assume-yes install rsync wget unzip git p7zip-full dos2unix net-tools
sudo apt-get --assume-yes install imagemagick xclip libglu1-mesa-dev libgl1-mesa-dev libsdl1.2-dev libpng-dev
sudo apt-get --assume-yes install mingw-w64 build-essential


cd $SCRIPTSDIR

./crossInstallLibrary.sh sdkdisc libz libpng libsdl
