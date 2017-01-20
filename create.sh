#! /bin/bash

LAUNCHDIR="$PWD"
EXPECTED_HOME="studiodev"

export CATALINA_HOME=/usr/local/Cellar/tomcat7/7.0.64/libexec

if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "create.sh githubusername"
    exit 1
fi

if [[ "$PWD" != *"$EXPECTED_HOME" ]]; then 
    echo "Must be run from studiodev repo directory"
    exit 1
fi

echo "###############"
echo "Enter your password for sudo if prompted"
echo "###############"

echo
echo "Creating media mount directory"

if [ ! -d "/Users/media" ]; then
    sudo mkdir -p /Users/media || exit $?
    sudo chown `whoami` /Users/media || exit $?
fi

# tomcat install
brew install tomcat7
cd $LAUNCHDIR/tomcatconfig
./config.sh
cd ..

# install media tools
brew install mediainfo
brew install imagemagick
brew install ffmpeg

echo
echo "Cloning repos for github user $1"

repos=( "studio-docker" "reach-engine" "studio" )

cd ..

for i in "${repos[@]}"
do
  if [ ! -d "$i" ]; then
    git clone https://github.com/$1/$i.git || exit $?
    git remote add upstream https://github.com/levelsbeyond/$i.git
  fi
done

cd $EXPECTED_HOME
#./build.sh
