# Development Dockerfile for OMERO
# --------------------------------
# This dockerfile can be used to build a
# distribution which can then be run
# within a number of different Docker images.

# By default, building this dockerfile will use
# the IMAGE argument below for the runtime image.
ARG IMAGE=openjdk:8-jre-alpine

# To install the built distribution into other runtimes
# pass a build argument, e.g.:
#
#   docker build --build-arg IMAGE=openjdk:9 ...
#

# Similarly, the BUILD_IMAGE argument can be overwritten
# but this is generally not needed.
ARG BUILD_IMAGE=gradle:jdk8

#
# Build phase: Use the gradle image for building.
#
FROM ${BUILD_IMAGE} as build
USER root
RUN apt-get -y update \
 && apt-get -y install gnupg2 software-properties-common
RUN apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv B6391CB2CFBA643D \
 && apt-add-repository "deb http://zeroc.com/download/Ice/3.7/debian9 stable main" \
 && apt-get -y update \
 && apt-get -y install zeroc-ice-all-runtime zeroc-ice-all-dev \
 && apt-get -y install python-zeroc-ice
RUN mkdir /src && chown 1000:1000 /src

USER 1000

# Temporarily build gradle-plugins locally
RUN git clone git://github.com/ome/omero-gradle-plugins /tmp/omero-gradle-plugins
WORKDIR /tmp/omero-gradle-plugins
RUN git submodule update --init
RUN ./build.sh

# Initialize submodules
WORKDIR /src
COPY --chown=1000:1000 .git /src/.git
COPY --chown=1000:1000 .gitmodules /src/.gitmodules
RUN git submodule update --init

# Build all
COPY --chown=1000:1000 *.gradle /src/
COPY --chown=1000:1000 gradle.properties /src/
RUN gradle build -x test
