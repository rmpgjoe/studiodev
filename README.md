# Reach Engine Developer Environment

## Contents

* [Environment Overview](#environment-overview)
* [Create Environment](#create-environment)
* [Syncing the Projects](#sync)
* [Environment Dependencies](#environment-dependencies)
* [Environment Configuration](#environment-configuration)
* [Launch](#launch)
* [Troubleshooting](#troubleshooting)
* [TODO](#todo)

## Environment Overview

This environment uses the ijdeploy docker environment, a local tomcat install, and an IntelliJ internal launcher for development, deploying, and debugging.

The environment setup will, as needed:
- Install tomcat in the standardized location on your machine (~/tomcat) and configure it
- clone the dependent repos for the project setup and configure upstream repos
- provide a preconfigured IntelliJ environment and launcher
- setup a media repository to share between host and docker environments
- kick off an initial maven build to generate initial sources and validate repos

It depends on:
- ijdeploy docker environment

## Create Environment

- Create a directory on your machine that will hold your reach code
- Fork-and-Clone this repository into that directory
- Fork-and-Clone studio-docker: https://github.com/levelsbeyond/studio-docker
- Fork-and-Clone studio: https://github.com/levelsbeyond/studio
- Fork-and-Clone reach-engine: https://github.com/levelsbeyond/reach-engine
- from the terminal, go into this repo and run ./create.sh <githubusername>
- if prompted, enter your local machine password for sudo
- once complete, open this repo as a intellij project
  - auto-import maven projects when prompted
  - configure spring components when prompted
- Make sure the tomcat IntelliJ plugin is installed & enabled
  - Point your IntelliJ tomcat server installation to ~/tomcat
- Build your ijdeploy docker images (see studio-docker repo and docs)
  
## Sync

Whenever you have to synchronize your maven projects (such as now on 
import), IntelliJ will overwrite your artifact definition.
That will remove your developer environment and class deployment from 
the artifact. 

To fix this:
- Open File -> Project Structure (cmd-;)
- Go to artifacts
- Select the 're-studio-server:war exploded' artifact
- In the 'Available Elements ?' column, right click `studiodev` and select 'put in WEB-INF/classes'
- Repeat for any modules you are editing to include your changes in redeploys

## Environment dependencies

IntelliJ uses the ~/tomcat deployment and its Log4J.properties
and context.xml to internally launch the application. Other external 
dependencies are managed in by the studio-docker/ijdeploy docker images.
They will setup /Users/media for a shared filesystem. See 
ijdeploy/README.md.

Docker images must be running before launching application.

## Environment Configuration

The launch will deploy and use the files in studiodev/devenv for application 
configuration.

## Launch

This should hopefully be the easy part. Make sure you have the docker ijdeploy environment up and running. On the launch bar in IntelliJ, select studio in the drop down and click the Run arrow or Debug bug.

When making changes to your running environment, you can "Update" to deploy updated resources and classes without restarting the machine.

## Troubleshooting

The vast majority of issues with this environment are keeping IntelliJ's
project definitions in sync with maven. That overwrites the artifact 
definition that IntelliJ uses to deploy. That is stored at .idea/artifacts/re_studio_war_exploded.xml.

### Lost configuration

If you see:

```
SEVERE: Servlet [re-mule] in web application [] threw load() exception
javax.servlet.ServletException: Property mule.context not set on ServletContext
```

or

```
Caused by: com.mongodb.MongoTimeoutException: Timed out after 30000 ms while waiting for a server that matches ReadPreferenceServerSelector{readPreference=primary}. Client view of cluster state is {type=UNKNOWN, servers=[{address=mongodb:27017, type=UNKNOWN, state=CONNECTING, exception={com.mongodb.MongoSocketException: mongodb}, caused by {java.net.UnknownHostException: mongodb}}]
```

Then you have most likely lost your studiodev compile output from your artifact definition. See [Sync](#sync).

### Changes not being deployed

If you are making code changes and not seeing them effect your launch, the project you are effecting is probably not getting its class files directly deployed into your artifact. Add the compile output for your project to the artifact as described in [Sync](#sync).

## TODO
