# Development Dockerfile for OMERO
# --------------------------------
# This dockerfile can be used to build a
# distribution which can then be run
# within a number of different Docker images.

# To install the built distribution into other runtimes
# pass a build argument, e.g.:
#
#   docker build --build-arg IMAGE=openjdk:9 ...
#

# Similarly, the BUILD_IMAGE argument can be overwritten
# but this is generally not needed.
ARG BUILD_IMAGE=gradle:5.2.1-jdk8

#
# Build phase: Use the gradle image for building.
#
FROM ${BUILD_IMAGE} as build
USER root
RUN apt-get update -qq && apt-get install -y -qq zeroc-ice-all-dev
RUN mkdir /src && chown 1000:1000 /src

USER 1000

# Temporarily build gradle-plugins locally
RUN git clone -b m4 git://github.com/rgozim/omero-gradle-plugins /tmp/omero-gradle-plugins
WORKDIR /tmp/omero-gradle-plugins
RUN git submodule update --init
RUN gradle publishToMavenLocal

# Initialize submodules
WORKDIR /src
COPY --chown=1000:1000 .git /src/.git
COPY --chown=1000:1000 .gitmodules /src/.gitmodules
RUN git submodule update --init

# Build all
COPY --chown=1000:1000 *.gradle /src/
COPY --chown=1000:1000 gradle.properties /src/

#RUN gradle build -x test
RUN gradle publishToMavenLocal -x javadoc
