#!/bin/bash

if [ -z "$CATALINA_HOME" ]; then
   echo "CATALINA_HOME must be set to run this setup script";
   exit 1
fi

cp context.xml $CATALINA_HOME/conf/
cp log4j.properties $CATALINA_HOME/lib/
