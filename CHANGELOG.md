5.7.5 (December 2023)
---------------------

- Bump omero-common version to 5.6.4.

5.7.4 (September 2023)
----------------------

- Bump omero-common version to 5.6.3.
- Add top-level Git mailmap

5.7.3 (July 2023)
-----------------

- Bump omero-common version to 5.6.2.

5.7.2 (March 2023)
------------------

- Push to releases folder on artifactory ([#42](https://github.com/ome/omero-romio/pull/42))
- Bump omero-common version to 5.6.1.

5.7.1 (December 2022)
---------------------

- Bump to TestNG 7.5 ([#34](https://github.com/ome/omero-romio/pull/33))
- Bump omero-common version to 5.6.0.

5.7.0 (June 2022)
------------------

- Add new ConfigureTileSizes constructor and make the pyramidal requirement for floating-point pixel types configurable ([#37](https://github.com/ome/omero-romio/pull/37))
- Bump omero-common version to 5.5.10 ([#38](https://github.com/ome/omero-romio/pull/38))
- Bump org.openmicroscopy.project plugin to 5.5.4 ([#38](https://github.com/ome/omero-romio/pull/38))
- Add Gradle publication workflow ([#38](https://github.com/ome/omero-romio/pull/38))


5.6.4 (April 2022)
------------------

- Bump omero-common version to 5.5.9.

5.6.3 (April 2022)
------------------

- Use maven central ([#30](https://github.com/ome/omero-romio/pull/30))
- Build with Gradle 6 ([#29](https://github.com/ome/omero-romio/pull/29))
- Log the version of Bio-Formats ([#28](https://github.com/ome/omero-romio/pull/28))
- Bump omero-common version to 5.5.8.


5.6.2 (September 2020)
----------------------

- Bump omero-common version to 5.5.7.

5.6.1 (July 2020)
-----------------

- Bump omero-common version to 5.5.6.

5.6.0 (May 2020)
----------------

- Remove junit dependency ([#19](https://github.com/ome/omero-romio/pull/19))
- Allow sub-classes, etc. to call getPath()  ([#21](https://github.com/ome/omero-romio/pull/21))

5.5.5 (March 2020)
------------------

- Display unit test output instead of caching it
  ([#17](https://github.com/ome/omero-romio/pull/17))
- Security vulnerability fix for
  [2019-SV1](https://www.openmicroscopy.org/security/advisories/2019-SV1-reader-used-files/)
- Bump omero-common version to 5.5.5.

5.5.4 (February 2020)
---------------------

- Allow for the retrieval of current file mode ([#16](https://github.com/ome/omero-romio/pull/16))
- Bump omero-common version to 5.5.4.

5.5.3 (December 2019)
---------------------

- Bump omero-common version.

5.5.2 (July 2019)
-----------------

- Bump omero-common version.

5.5.1 (June 2019)
-----------------

- Bump omero-common version.

5.5.0 (May 2019)
----------------

- PixelsPyramidReader: Set canSeperateSeries for BF 6.1.0.
- FailedTileLoopException becomes a checked exception.
- Add License file.
- Run units test in Travis.
- Fix Javadoc warnings.
- Use new Gradle build system.
- Properly name PixelsService.nullPlane
- Extract omero-romio from the openmicroscopy repository.
