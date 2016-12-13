# Reach Engine Developmer Environment

## Contents

* [Configuration](#configuration)
  * [Setup Instructions](#setup-instructions)
* [Execution](#execution)
* [TODO](#todo)

## Setup environment

- Create a clone of this repository for your use managing your env
- Create a directory on your machine that will hold your reach code
- Clone this repository into that directory
- from the terminal, go into this repo and run ./create.sh <githubusername>
- if prompted, enter your local machine password for sudo
- once complete, open this repo as a intellij project
  - auto-import maven projects when prompted
  - configure spring components when prompted
- Make sure the tomcat IntelliJ plugin is installed & enabled
  - Point your IntelliJ tomcat server installation to /usr/local/tomcat

  
## Keeping your environment/artifact in sync

Whenever you have to synchronize your maven projects (such as now on 
import), IntelliJ will helpfully overwrite your artifact definition.
That will remove your developer environment and class deployment from 
the artifact. To fix this:
- Open Project Structure
- Go to artifacts
- Edit the re-studio-server:war exploded artifact
- Click the context menu on redev compile output and put in 
WEB-INF/classes
- Repeat for any modules you are editing to include your changes in 
redeploys

## Environment dependencies

IntelliJ uses the /usr/local/tomcat deployment and its Log4J.properties
and context.xml to internally launch the application. Other external 
dependencies are managed in by the studio-docker/ijdeploy docker images.
They will setup /Users/media for a shared filesystem. See 
ijdeploy/README.md.

Docker images must be running before launching application.

## Environment Configuration

The launch will deploy and use the files in redev/devenv for application 
configuration.

## Launch

This should hopefully be the easy part. On the launch bar in IntelliJ,
select studio in the drop down and click the Run arrow or Debug bug.