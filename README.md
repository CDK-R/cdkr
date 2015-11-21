Build Instructions
------------------

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

For the png package, I have tested [png-0.1-4](http://www.rforge.net/png/files/)

## rpubchem

Allows you to access Pubchem structures and bioassay data. The `pug-rest` branch supports retrieval of any AID (even primary screens, though this can be quite slow) or subsets of a screen by CID or SID. To install
```R
library(devtools)
install_github("rajarshi/cdkr@pug-rest", subdir="rpubchem")
```
Once installed you can retrieve assays using the `get.assay` method:
```R
## Retrieve the whole of AID 2044
dat <- get.assay(2044)

## Retrieve data for CIDs 644411, 645075 and 645739 from AID 361 (a large screen with 50K compounds)
dat <- get.assay(361, cid=c(644411,645075,645739), quiet=FALSE)
```