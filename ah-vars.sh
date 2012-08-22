#!/bin/bash

if [ "$1" = "release" ]; then
  export AH_SNAPSHOTS_RELEASES=releases
  export AH_REPO_URL="http://maven.research.rackspacecloud.com/content/repositories/$AH_SNAPSHOTS_RELEASES/org/atomhopper/atomhopper"
  export AH_VERSION=`curl -s $AH_REPO_URL/maven-metadata.xml | xpath '//version[last()]/text()' 2>/dev/null`
  export AH_BASENAME=atomhopper-$AH_VERSION
else
  export AH_SNAPSHOTS_RELEASES=snapshots
  export AH_REPO_URL="http://maven.research.rackspacecloud.com/content/repositories/$AH_SNAPSHOTS_RELEASES/org/atomhopper/atomhopper"
  export AH_VERSION=`curl -s $AH_REPO_URL/maven-metadata.xml | xpath '//version[last()]/text()' 2>/dev/null`
  AH_BUILD_TIMESTAMP=`curl -s $AH_REPO_URL/$AH_VERSION/maven-metadata.xml | xpath '/metadata/versioning/snapshot/timestamp/text()' 2>/dev/null`
  AH_BUILD_NUMBER=`curl -s $AH_REPO_URL/$AH_VERSION/maven-metadata.xml | xpath '/metadata/versioning/snapshot/buildNumber/text()' 2>/dev/null`
  AH_BUILD=`curl -s $AH_REPO_URL/$AH_VERSION/maven-metadata.xml | xpath '//snapshotVersion[extension="war"]/value/text()' 2>/dev/null`
  export AH_BASENAME=atomhopper-$AH_BUILD
fi

export AH_FILE="${AH_BASENAME}.war"

export AH_ARTIFACT_URL=$AH_REPO_URL/$AH_VERSION/$AH_FILE

