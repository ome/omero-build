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

ARG RUN_IMAGE=adoptopenjdk:11-jdk-hotspot-bionic

#
# Build phase: Use the gradle image for building.
#
FROM ${BUILD_IMAGE} as build
USER root
RUN apt-get update -qq && apt-get install -y -qq zeroc-ice-all-dev
RUN mkdir /src && chown 1000:1000 /src

# Build all
USER 1000

COPY --chown=1000:1000 . /src
WORKDIR /src
RUN gradle publishToMavenLocal -x javadoc

FROM ${RUN_IMAGE} as run
RUN id 1000 || useradd -u 1000 -ms /bin/bash build
COPY --chown=1000:1000 --from=build /home/gradle/.m2/ /home/build/.m2
