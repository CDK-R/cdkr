# Test environments
* OS X, R 3.2.3
* win-builder (devel and release)

## R CMD check results

There is one NOTE:

* checking CRAN incoming feasibility ... NOTE
  New maintainer:
    Zachary Charlop-Powers <zach.charlop.powers@gmail.com>
  Old maintainer(s):
    Rajarshi Guha <rajarshi.guha@gmail.com>
    
  The previous Maintainer has asked for assistence in releaseing this software. Please
  see https://github.com/rajarshi/cdkr/issues/31

    
Possibly mis-spelled words in DESCRIPTION:
  API (16:25)
  CDK (4:25, 14:5, 16:21)
  
  These are spelled correctly.


## Note to Package Reviewers

This package is intended to accomany the rcdklibs_1.5.13 package. That library introduces new, breaking changes in the underlying CDK library and this update makes the rcdk comaptable with that  update.
