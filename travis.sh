#!/usr/bin/env bash
set -e
set -u
set -x

printf "travis_fold:start:checkout\n"
test -e openmicroscopy || git clone --depth=1 git://github.com/openmicroscopy/openmicroscopy.git
test -e openmicroscopy/.build || git clone git://github.com/ome/build-infra.git openmicroscopy/.build
test -e openmicroscopy/.omero || git clone git://github.com/openmicroscopy/omero-test-infra.git openmicroscopy/.omero
printf "travis_fold:end:checkout\n"

openmicroscopy/.build/omero-image
export BUILD_IMAGE=$(docker inspect --format='{{ .Id }}' omero-build)
echo $BUILD_IMAGE

cd openmicroscopy/
printf "travis_fold:start:test-infra\n"
export COMPOSE_FILE=srv-compose.yml
.omero/compose up -d
.omero/docker dev install
.omero/docker dev wait_on_login
printf "travis_fold:end:test-infra\n"
