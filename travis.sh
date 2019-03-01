#!/usr/bin/env bash
set -e
set -u
set -x
test -e build-infra || git clone git://github.com/ome/build-infra.git
test -e openmicroscopy || git clone -b reuse-docker git://github.com/joshmoore/openmicroscopy.git
test -e openmicroscopy/.omero || git clone -b srv-compose git://github.com/joshmoore/omero-test-infra.git openmicroscopy/.omero

# build-infra/recursive-merge # Updates versions
git submodule foreach "sed -ie 's/\(omero-.*:5.5.0\)-m3/\1-SNAPSHOT/' build.gradle"

# For the moment: hard-coding these properties
echo versions.omero-blitz=5.5.0-SNAPSHOT >> openmicroscopy/etc/omero.properties
echo versions.omero-common-test=5.5.0-SNAPSHOT >> openmicroscopy/etc/omero.properties

export BUILD_IMAGE=$(docker build -q -t omero-build . 2>/dev/null | awk '/Successfully built/{print $NF}')
cd openmicroscopy
.omero/docker srv
