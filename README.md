[![Build Status](https://api.travis-ci.org/rajarshi/cdkr.svg?branch=master)](https://travis-ci.org/rajarshi/cdkr)

## rcdk


If you use ```devtools```, installing the packages can be done by
```R
library(devtools)
install_github("rajarshi/rcdklibs")
install_github("rajarshi/cdkr", subdir="rcdk")
```

Otherwise if you prefer the command line
``` 
	cd /tmp/
	git clone git@github.com:rajarshi/rcdklibs.git
	R CMD INSTALL rcdklibs
	git clone git@github.com:rajarshi/cdkr.git
	cd cdkr/rcdkjar
	ant clean jar
	cd ../
	R CMD INSTALL rcdk
```
Before performing the install, you should have the following dependencies installed:

* rJava
* fingerprint
* png
* RUnit
* Java JDK >= 1.8


For the png package, I have tested [png-0.1-7](http://www.rforge.net/png/files/)

Some users have reported that `rcdk` methods (such as `parse.smiles`) are returning errors related to class not found or class version mismatch. This can happen when you are using a prepackaged version of `rJava` from [CRAN](https://cran.r-project.org/) and is caused by that package not finding the correct JRE home if you have multiple Java versions installed. In such a case, reinstalling `rJava` from sources appears to resolve this issue. See this [discussion](http://stackoverflow.com/questions/26948777/how-can-i-make-rjava-use-the-newer-version-of-java-on-osx).

## Installing Java

rCDK uses the CDK library that requires the Java JDK >= 1.8. In order to install rCDK, this requirement must be satisfied. You can check your java version on the command line as follows:

```
> java -version
> java version "1.8.0"
```

If your version is not 1.8 you may need to download and install a more recent installation of JAVA.  If you have multiple versions of JAVA you may be using an older version. On Mac OSX, for example, the latest OS installs JAVA 1.6 and you will need to reconfigure your JAVA install. You can try the following: 

```
# set the java version
R CMD javareconf  # or ....
sudo R CMD javareconf

# re install fromfrom R
install.packages('rJava', type="source")
```

Further informaiton about R's use of Java can be [found here](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Java-support). 
