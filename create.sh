#! /bin/bash

CATALINA_VERSION=7.0.47
CATALINA_ROOT=~/.reachengine/tomcat
LAUNCHDIR="$PWD"
EXPECTED_HOME="studiodev"

export CATALINA_HOME=$CATALINA_ROOT/apache-tomcat-$CATALINA_VERSION

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
if [ ! -d $CATALINA_HOME ]; then
    cd
    mkdir -p $CATALINA_ROOT
    mkdir -p $CATALINA_HOME
    cd ~/Downloads
    curl "https://s3.amazonaws.com/studio-install-stuff/apache-tomcat-$CATALINA_VERSION.tar.gz" -o "apache-tomcat-$CATALINA_VERSION.tar.gz"
    tar -xzvf apache-tomcat-$CATALINA_VERSION.tar.gz
    mv apache-tomcat-$CATALINA_VERSION/* $CATALINA_HOME
fi

#tomcat configure
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
    cd $i
    git remote add upstream https://github.com/levelsbeyond/$i.git
    cd ..
  fi
done

cd $EXPECTED_HOME
#./build.sh
