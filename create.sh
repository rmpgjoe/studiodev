#! /bin/bash

export CATALINA_HOME="/usr/local/tomcat"
LAUNCHDIR="$PWD"
EXPECTED_HOME="redev"

if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "create.sh githubusername"
    exit 1
fi

if [[ "$PWD" != *"$EXPECTED_HOME" ]]; then 
    echo "Must be run from redev repo directory"
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
if [ ! -d "/usr/local/tomcat" ]; then
  cd
  wget https://s3.amazonaws.com/studio-install-stuff/apache-tomcat-7.0.47.tar.gz
  tar -xzvf apache-tomcat-7.0.47.tar.gz
  sudo mv apache-tomcat-7.0.47/ $CATALINA_HOME
  cd $LAUNCHDIR/tomcatconfig
  ./config.sh
  cd ..
fi

echo
echo "Cloning repos for github user $1"

repos=( "studio-docker" "reach-engine" "studio-services" "nimbus" "studio" )

cd ..

for i in "${repos[@]}"
do
  if [ ! -d "$i" ]; then
    git clone https://github.com/$1/$i.git || exit $?
    git remote add upstream https://github.com/levelsbeyond/$i.git
  fi
done

cd $EXPECTED_HOME
./build.sh
