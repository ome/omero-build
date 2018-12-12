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
COPY . /src
USER root
RUN cat /etc/apt/sources.list
RUN apt-get update && apt-get install -y zeroc-ice-all-dev
RUN chown -R 1000 /src
USER 1000
RUN git clone git://github.com/ome/omero-dsl /tmp/omero-dsl
WORKDIR /tmp/omero-dsl
RUN gradle publishToMavenLocal
WORKDIR /src
RUN git submodule update --init
RUN gradle build

#
# Install phase: Copy the build ImageJ.app into a
# clean container to minimize size.
#
# FROM ${IMAGE}
# COPY --from=build /src/ /opt/omero
ENV PATH $PATH:/opt/omero
ENTRYPOINT ["bash"]
