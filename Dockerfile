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

# Build all
USER 1000

# Temporarily build gradle-plugins locally
RUN echo 2
RUN git clone -b m4-squashed git://github.com/joshmoore/omero-gradle-plugins /tmp/omero-gradle-plugins
WORKDIR /tmp/omero-gradle-plugins
RUN git submodule update --init
RUN gradle publishToMavenLocal

COPY --chown=1000:1000 . /src
WORKDIR /src
RUN gradle publishToMavenLocal -x javadoc
