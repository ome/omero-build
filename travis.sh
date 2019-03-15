#!/usr/bin/env bash
set -e
set -u
set -x

test -e .build || git clone git://github.com/ome/build-infra.git .build
export PATH=$PATH:$PWD/.build

build-phase checkout
test -e openmicroscopy || git clone --depth=1 git://github.com/openmicroscopy/openmicroscopy.git
test -e openmicroscopy/.build || ln -s $PWD/.build openmicroscopy/.build
test -e openmicroscopy/.omero || git clone git://github.com/openmicroscopy/omero-test-infra.git openmicroscopy/.omero

build-phase setup
foreach-set-dependencies
foreach-get-version-as-property >> openmicroscopy/etc/omero.properties

build-phase build_image
docker build -t omero-build .
export BUILD_IMAGE=$(docker inspect --format='{{ .Id }}' omero-build)
echo $BUILD_IMAGE

build-phase test_infra
cd openmicroscopy
export COMPOSE_FILE=srv-compose.yml
.omero/compose up -d
.omero/docker dev install
.omero/docker dev wait_on_login
