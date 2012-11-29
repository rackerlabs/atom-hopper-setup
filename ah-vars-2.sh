#!/bin/bash

AH_FOLDER=atomhopper
AH_EXT=war
AH_BASE=$AH_FOLDER

export AH_SNAPSHOTS_RELEASES=snapshots

export AH_VERSION="1.2.2-SNAPSHOT"
export AH_BUILD=$AH_VERSION
export AH_BASENAME=$AH_BASE-$AH_BUILD
export AH_FILE="${AH_BASENAME}.war"
export AH_ARTIFACT_URL="$1"

