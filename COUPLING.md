Coupling Builds
===============

Each of the submodules in this repository is a Java component which manages its
own version number. This facilitates releasing individual changes more rapidly.
A downside of this is that building and testing certain changes together
can take more effort. Below are tips for producing such "re-coupled" builds.

Version States
--------------

Java component repositories are always in one of two states:

 - the tagged release commit with a version like 5.5.0
 - a snapshot commit with a version like 5.5.1-SNAPSHOT

Building either of those states locally will allow you to test that particular
component. But the *dependencies* of that component should *never* point to
SNAPSHOT versions, meaning that testing how omero-server behaves when
omero-model has been moved to a SNAPSHOT version is less easy.

Version Chain
-------------

In OMERO, there is a chain of dependencies from the clients down through
the server to the lowest-level code:

    omero-insight depends on
      --> omero-gateway which depends on
        --> omero-blitz which depends on
          --> omero-server which depends on
            --> omero-renderer which depends on
              --> omero-romio which depends on
                --> omero-common which depends on
                  --> omero-model which depends on
                    --> Bio-Formats' formats-gpl jar

Version Definitions
-------------------

The version of a component along with the artifact id and the now standard
groupId of "org.openmicroscopy" are all specified in the build.gradle file. The
same is true for all dependencies. Where possible, a component should refer to
exactly **one** dependency in this chain to prevent confusion.

The openmicroscopy build which is not yet written in gradle specifies its
version in **etc/omero.properties**. Also, unlike all the other versions, a
synthetic version gets generated for the OMERO.server.zip. The top level
`openmicroscopy` build generates a version from `git describe` so that you can
tell builds apart.

Generally though, unless a commit represents a tag, all repositories should
have their version set to something ending in `-SNAPSHOT`. For a release, the
version is bumped, that commit is tagged, and then the version is rolled back
to `SNAPSHOT`, incrementing to the next (target) version number if it's not a
milestone release.

Superprojects
-------------

The version dependencies are encoded in the repositories themselves and
therefore don't need superprojects and submodules to build a consistent state.
However, having an easy way to iterate over all of the subitems is generally
useful, for example by running `git submodule foreach`.

When working on a single repository, you can choose whether to check out a
single project or to check out the supermodule with the other projects. If you
are working on more than a single repository at a time, the latter is likely
easier. And in that case, properly testing a set of PRs will also require
opening a PR against this repository. Travis builds in the individual
repositories is of minimal value for breaking changes

Version Tooling
---------------

In order to coordinate all the versions described above, scripts have been
collected in the [build-infra](https://github.com/ome/build-infra) repository.
These scripts make use of the checked out submoduels and `git submodule foreach`
to update version variables to match your local directory.
