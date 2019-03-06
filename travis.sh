#!/usr/bin/env bash
set -e
set -u
set -x

printf "travis_fold:start:checkout\n"
test -e build-infra || git clone git://github.com/ome/build-infra.git
test -e openmicroscopy || git clone --depth=1 -b reuse-docker git://github.com/joshmoore/openmicroscopy.git
test -e openmicroscopy/.omero || git clone git://github.com/openmicroscopy/omero-test-infra.git openmicroscopy/.omero
printf "travis_fold:end:checkout\n"

# build-infra/recursive-merge # Updates versions
printf "travis_fold:start:bump-versions\n"
git submodule foreach "sed -ie 's/\(omero-.*:5.5.0\)-m3/\1-SNAPSHOT/' build.gradle"
# For the moment: hard-coding these properties
echo versions.omero-blitz=5.5.0-SNAPSHOT >> openmicroscopy/etc/omero.properties
echo versions.omero-common-test=5.5.0-SNAPSHOT >> openmicroscopy/etc/omero.properties
printf "travis_fold:end:bump-versions\n"

printf "travis_fold:start:build-image\n"
docker build -t omero-build .
export BUILD_IMAGE=$(docker inspect --format='{{ .Id }}' omero-build)
echo Build image: $BUILD_IMAGE
printf "travis_fold:end:build-image\n"

printf "travis_fold:start:build-infra\n"
cd openmicroscopy
COMPOSE_FILE=srv-compose.yml .omero/compose build
printf "travis_fold:end:build-infra\n"

printf "travis_fold:start:test-infra\n"
export COMPOSE_FILE=srv-compose.yml
.omero/compose up -d
.omero/docker dev install
.omero/docker dev wait_on_login
printf "travis_fold:end:test-infra\n"
