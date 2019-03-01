#!/usr/bin/env bash
set -e
set -u
set -x

printf "travis_fold:start:checkout\n"
test -e build-infra || git clone git://github.com/ome/build-infra.git
test -e openmicroscopy || git clone --depth=1 -b reuse-docker git://github.com/joshmoore/openmicroscopy.git
test -e openmicroscopy/.omero || git clone -b srv-compose git://github.com/joshmoore/omero-test-infra.git openmicroscopy/.omero
printf "travis_fold:end:checkout\n"

# build-infra/recursive-merge # Updates versions
printf "travis_fold:start:bump-versions\n"
git submodule foreach "sed -ie 's/\(omero-.*:5.5.0\)-m3/\1-SNAPSHOT/' build.gradle"
# For the moment: hard-coding these properties
echo versions.omero-blitz=5.5.0-SNAPSHOT >> openmicroscopy/etc/omero.properties
echo versions.omero-common-test=5.5.0-SNAPSHOT >> openmicroscopy/etc/omero.properties
printf "travis_fold:end:bump-versions\n"

printf "travis_fold:start:build-image\n"
export BUILD_IMAGE=$(docker build -q -t omero-build . | awk '/Successfully built/{print $NF}')
printf "travis_fold:end:build-image\n"

printf "travis_fold:start:test-infra\n"
cd openmicroscopy
.omero/docker srv --all
printf "travis_fold:end:test-infra\n"
