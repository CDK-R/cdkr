[![Build Status](https://api.travis-ci.org/rajarshi/cdkr.svg?branch=master)](https://travis-ci.org/rajarshi/cdkr)

## rcdk


If you use ```devtools```, installing the packages can be done by
```R
library(devtools)
install_github("rajarshi/cdkr", subdir="rcdklibs")
install_github("rajarshi/cdkr", subdir="rcdk")
```

Otherwise if you prefer the command line
``` 
	R CMD build rcdklibs
	R CMD INSTALL rcdklibs_*gz
	cd rcdkjar
	ant clean jar
	cd ../
	R CMD build rcdk
	R CMD INSTALL rcdk_*gz
```
Before performing the install, you should have the following dependencies installed:

* rJava
* fingerprint
* png
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


## rpubchem

Allows you to access [PubChem](https://pubchem.ncbi.nlm.nih.gov/) structures and bioassay data. The package supports retrieval of any AID (even primary screens, though this can be quite slow) or subsets of a screen by CID or SID. To install
```R
library(devtools)
install_github("rajarshi/cdkr", subdir="rpubchem", dependencies=TRUE)
```
Once installed you can retrieve assays using the `get.assay` method:
```R
## Retrieve the whole of AID 2044
dat <- get.assay(2044)

## Retrieve data for CIDs 644411, 645075 and 645739 from AID 361 (a large screen with 50K compounds)
dat <- get.assay(361, cid=c(644411,645075,645739), quiet=FALSE)
```
You can search for assays using text search as well as obtain the description (which actually includes the description, comments and column types) for an assay by AID. In addition to the description, we can obtain the summary section, which includes, among other things, counts of actives, inactives and so on
```R
## find assay ID's related to yeast
aids <- find.assay.id('yeast')

## get the description of the first 10 assays
descs <- sapply( lapply(aids[1:10], get.assay.desc), function(x) x$assay.desc )

## get assay summary for the first one
get.assay.summary(aids[1])
```
