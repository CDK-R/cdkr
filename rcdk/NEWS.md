# rcdk 3.7.0

* Update rCDK to work with rcdklibs 2.8


# rcdk 3.6.0

* Fix code to handle changes to JDK17. Notably, I needed to reduce the use of the J notation in a nubmer of places in favor of direct calls.
* formally deprecated `do.typing` in favor of `set.atom.types`
* Updated handling of atomic descriptors to resolve a name mismatch bug
* Added a test case for atomic descriptors (thanks to Francesca Di Cesare)
* Updated @export annotation with function name to avoid interpretation as 
  S3 method
* Refactored do.typing to set.atom.types and updated to use J notation
* Refactored methods to use the renamed function

# rcdk 3.5.1

* minor update to make bond order enums available when setting the order of pre-exisitng bonds

# rcdk  3.5.0

* update to RCDKlibs 2.3. This changes uderlying AtomContainer defualt to Atomcontainer2 and also has new support for mass spec mass functions. On the rcdk side we have moved to a tidyverse documentation and build system.

# rcdk  3.4.7 

* minor update to comply with CRAN policy. Minimum Java 8 required; fix an issue where unittests were writing to system files.

# v3.3.5 

* update to work with CDK 1.5.13 with the new Depiction module

# v2.9

* Updated to the new package structure where the CDK libs are removed. As a result, this package now depends on the rcdklibs package

# v2.8.1 

* Fixed typos in the docs

# v2.8 

* Updated code to provide accessors for atoms and bonds of a molecule. 
* Also provide methods to access atom and bond properties. Currently, setters
for these objects are not provided

# v2.7 

* Removed support for JChemPaint due to it being in flux at this point. Also 
removed support for viewing tables of 3D structures. Restructured the descriptor
functions to utilize descriptor names and i general make descriptor calculations
more R-like


