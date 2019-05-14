[![Build Status](https://travis-ci.org/ome/omero-build.png)](https://travis-ci.org/ome/omero-build)

# omero-build

A Gradle super project. All sub-projects are added as submodule.
This project is a [Gradle composite build](https://docs.gradle.org/current/userguide/composite_builds.html).


## Build from source

The compilation, publishing, and delivery of the applications are
automated by means of a Gradle (https://gradle.org/) build file.
In order to perform a publish all sub-projects, all you need is
a JDK -- version 1.8 or later.
Clone this GitHub repository `git clone https://github.com/ome/omero-build.git`.

To list the available OMERO tasks, run:

  gradle tasks
