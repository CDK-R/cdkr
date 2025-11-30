# Changelog

## rcdk 3.8.2

- Update rCDK to work with rcdklibs 2.11

## rcdk 3.8.0

CRAN release: 2023-06-12

- Change DESCRIPTION in accordance with CRAN rules about JDKs
- Fix System Requirements line

## rcdk 3.7.0

CRAN release: 2022-09-26

- Update rCDK to work with rcdklibs 2.8

## rcdk 3.6.0

CRAN release: 2021-10-17

- Fix code to handle changes to JDK17. Notably, I needed to reduce the
  use of the J notation in a number of places in favor of direct calls.
- formally deprecated `do.typing` in favor of `set.atom.types`
- Updated handling of atomic descriptors to resolve a name mismatch bug
- Added a test case for atomic descriptors (thanks to Francesca Di
  Cesare)
- Updated [@export](https://github.com/export) annotation with function
  name to avoid interpretation as S3 method
- Refactored do.typing to set.atom.types and updated to use J notation
- Refactored methods to use the renamed function

## rcdk 3.5.1

- minor update to make bond order enums available when setting the order
  of pre-exisitng bonds

## rcdk 3.5.0

CRAN release: 2020-03-11

- update to RCDKlibs 2.3. This changes underlying AtomContainer default
  to Atomcontainer2 and also has new support for mass spec mass
  functions. On the rcdk side we have moved to a tidyverse documentation
  and build system.

## rcdk 3.4.7

CRAN release: 2018-04-30

- minor update to comply with CRAN policy. Minimum Java 8 required; fix
  an issue where unittests were writing to system files.
