
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Build
Status](https://api.travis-ci.org/CDK-R/cdkr.svg?branch=master)](https://travis-ci.org/CDK-R/cdkr)
[![CRAN
Version](https://www.r-pkg.org/badges/version/rcdk?color=green)](https://cran.r-project.org/package=rcdk)
[![CRAN
Downloads](http://cranlogs.r-pkg.org/badges/grand-total/rcdk?color=green)](https://cran.r-project.org/package=rcdk)
[![CRAN Downloads
Monthyl](http://cranlogs.r-pkg.org/badges/last-month/rcdk?color=green)](https://cran.r-project.org/package=rcdk)
[![R-CMD-check](https://github.com/zachcp/cdkr/workflows/R-CMD-check/badge.svg)](https://github.com/zachcp/cdkr/actions)

# rcdk: a chemistry library

The goal of cdkr is to provide easy access to
[CDK](https://github.com/cdk/cdk) chemoinformatics library to combine
the simplicity and power of R with CDK’s powerful, tested API.

# Installation

rCDK package releases are available on CRAN or on Github via Devtools:

``` r

# releases
install.packages("rcdk")

# development releases of `cdkr` are also available on github uinsg devtools:
library(devtools)
install_github("https://github.com/CDK-R/rcdklibs")
install_github("https://github.com/CDK-R/cdkr", subdir="rcdk")
```

## Building and Development

Information on building and devloping the CDKR package is available in
teh Otherwise if you prefer the command line

        cd /tmp/
        git clone git@github.com:CDK-R/rcdklibs.git
        R CMD INSTALL rcdklibs
        git clone git@github.com:CDK-R/cdkr.git
        cd cdkr/rcdkjar
        ant clean jar
        cd ../
        R CMD INSTALL rcdk

Before performing the install, you should have the following
dependencies installed:

- rJava
- fingerprint
- png
- RUnit
- Java JDK \>= 1.8

For the png package, I have tested
[png-0.1-7](http://www.rforge.net/png/files/)

Some users have reported that `rcdk` methods (such as `parse.smiles`)
are returning errors related to class not found or class version
mismatch. This can happen when you are using a prepackaged version of
`rJava` from [CRAN](https://cran.r-project.org/) and is caused by that
package not finding the correct JRE home if you have multiple Java
versions installed. In such a case, reinstalling `rJava` from sources
appears to resolve this issue. See this
[discussion](http://stackoverflow.com/questions/26948777/how-can-i-make-rjava-use-the-newer-version-of-java-on-osx).

### Installing Java

rCDK uses the CDK library that requires the Java JDK \>= 1.8. In order
to install rCDK, this requirement must be satisfied. You can check your
java version on the command line as follows:

    > java -version
    > java version "1.8.0"

If your version is not 1.8 you may need to download and install a more
recent installation of JAVA. If you have multiple versions of JAVA you
may be using an older version. On Mac OSX, for example, the latest OS
installs JAVA 1.6 and you will need to reconfigure your JAVA install.
You can try the following:

    # set the java version
    R CMD javareconf  # or ....
    sudo R CMD javareconf

    # re install fromfrom R
    install.packages('rJava', type="source")

Further informaiton about R’s use of Java can be [found
here](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Java-support).
