#!/usr/bin/env bash

set -e
set -u
set -x

for x in omero-model omero-common omero-romio omero-renderer omero-server omero-blitz;
do
    pushd $x
    ./gradlew clean publishToMavenLocal -x test -x javadoc
    popd
done
