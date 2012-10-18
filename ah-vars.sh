#!/bin/bash

if [ "$2" == "jetty" ]; then
  AH_FOLDER=ah-jetty-server
else
  AH_FOLDER=atomhopper
fi

if [ "$2" = "rpm" ]; then
  AH_EXT=rpm
elif [ "$2" == "war" ]; then
  AH_EXT=war
else
  AH_EXT=jar
fi
AH_BASE=$AH_FOLDER

if [ "$1" = "release" ]; then
  export AH_SNAPSHOTS_RELEASES=releases
  export AH_REPO_URL="http://maven.research.rackspacecloud.com/content/repositories/$AH_SNAPSHOTS_RELEASES/org/atomhopper/$AH_FOLDER"
  export AH_VERSION=`curl -s $AH_REPO_URL/maven-metadata.xml | xpath '//version[last()]/text()' 2>/dev/null`
  export AH_BASENAME=$AH_BASE-$AH_VERSION
else
  export AH_SNAPSHOTS_RELEASES=snapshots
  export AH_REPO_URL="http://maven.research.rackspacecloud.com/content/repositories/$AH_SNAPSHOTS_RELEASES/org/atomhopper/$AH_FOLDER"
  export AH_VERSION=`curl -s $AH_REPO_URL/maven-metadata.xml | xpath '//version[last()]/text()' 2>/dev/null`
  AH_BUILD_TIMESTAMP=`curl -s $AH_REPO_URL/$AH_VERSION/maven-metadata.xml | xpath '/metadata/versioning/snapshot/timestamp/text()' 2>/dev/null`
  AH_BUILD_NUMBER=`curl -s $AH_REPO_URL/$AH_VERSION/maven-metadata.xml | xpath '/metadata/versioning/snapshot/buildNumber/text()' 2>/dev/null`
  AH_BUILD=`curl -s $AH_REPO_URL/$AH_VERSION/maven-metadata.xml | xpath "//snapshotVersion[extension=\"$AH_EXT\" and (not(classifier) or classifier/text() != 'sources')]/value/text()" 2>/dev/null`
  export AH_BASENAME=$AH_BASE-$AH_BUILD
fi

if [ "$2" = "rpm" ]; then
  export AH_FILE="${AH_BASENAME}-rpm.rpm"
elif [ "$2" == "jetty" ]; then
  export AH_FILE="${AH_BASENAME}.jar"
else
  export AH_FILE="${AH_BASENAME}.war"
fi

export AH_ARTIFACT_URL=$AH_REPO_URL/$AH_VERSION/$AH_FILE

