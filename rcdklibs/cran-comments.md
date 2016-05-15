# Test environments
* OS X, R 3.2.3
* win-builder (devel and release)

## R CMD check results

There are two NOTEs:

* checking installed package size ... NOTE
  installed size is 25.6Mb
  sub-directories of 1Mb or more:
    cont  25.5Mb

  This is due to the inclusion of the Java CDK libraries. This package is updated rarely
  and the libraries are needed for funcitonality.


* checking CRAN incoming feasibility ... NOTE
  New maintainer:
    Zachary Charlop-Powers <zach.charlop.powers@gmail.com>
  Old maintainer(s):
    Rajarshi Guha <rajarshi.guha@gmail.com>
    
  The previous Maintainer has asked for assistence in releaseing this software. Please
  see https://github.com/rajarshi/cdkr/issues/31

    
  Possibly mis-spelled words in DESCRIPTION:
    CDK (9:12, 12:60, 14:23, 15:24)
    LGPL (15:58)
    chemoinformatics (11:5)
    rJava (14:33)
    rcdk (13:32, 14:48)
  
  These are spelled correctly.


## Note to Package Reviewers

This package has breaking changes in some of the APIs of the underlying Java library. It is
therefore incompatible with earlier versions of RCDK library which depends on this library.
I am uploading the new version of the RCDK library as well so that they can be reviewed at the 
same time. Although this is not recommended by CRAN, it was advised that I do it this way by 
Kurt Hornik when I recently submitted Rcdklibs by itself.

Furthermore, although this is a large library we are hoping for an exception on the grounds
that 1) it is updated very infrequently, 2) there are many new, useful features in this version
of CDK, and 3) there is not a community sanctioned alternative for the CRAN-friendly distribution 
of JAR files. I therefore hope we can be granted an exeption while we look for an alternative distribution method.
