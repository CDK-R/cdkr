.packageName <- "rcdklibs"

require(rJava, quietly=TRUE)

.onLoad <- function(lib, pkg) {
    dlp<-Sys.getenv("DYLD_LIBRARY_PATH")
    if (dlp!="") { # for Mac OS X we need to remove X11 from lib-path
        Sys.setenv("DYLD_LIBRARY_PATH"=sub("/usr/X11R6/lib","",dlp))
    }

    jar.cdk <- paste(lib,pkg,"cont","cdk.jar",sep=.Platform$file.sep)
    jar.jcp <- paste(lib,pkg,"cont","jcp16.jar",sep=.Platform$file.sep)
    .jinit(classpath=c(jar.cdk,jar.jcp))
}
    

