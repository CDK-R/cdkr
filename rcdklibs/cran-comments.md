# Test environments
* OS X, R 3.2.3
* win-builder (devel and release)

## R CMD check results

There are two NOTEs:

* checking installed package size ... NOTE
  installed size is 24.9Mb
  sub-directories of 1Mb or more:
    cont  24.8Mb
  
  This is due to the inclusion of the Java CDK libraries. This package is pdated rarely
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
