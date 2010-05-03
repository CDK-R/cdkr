Build Instructions
------------------

	R CMD BUILD rcdklibs
	cd rcdkjar
	ant clean jar
	cd ../
	R CMD BUILD rcdk
	
	R CMD INSTALL rcdklibs_*gz
	R CMD INSTALL rcdk_*gz

Before performing the install, you should have the following dependencies installed:

* rJava
* fingerprint
* png
* methods

For the png package, I have tested [png-0.1-2](http://www.rforge.net/png/files/)