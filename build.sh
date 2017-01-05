#! /bin/bash

EXPECTED_HOME="studiodev"

if [[ "$PWD" != *"$EXPECTED_HOME" ]]; then 
    echo "Must be run from studiodev repo directory"
    exit 1
fi

echo "Executing Maven Builds"

repos=( "reach-engine" "studio" )

if [[ "$1" == "-DskipTests" ]]; then
  FLAG="-DskipTests"
fi

for i in "${repos[@]}"
do
  cd ../$i
  mvn clean install $FLAG
done
