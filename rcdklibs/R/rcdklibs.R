.packageName <- "rcdklibs"

require(rJava, quietly=TRUE)

.onLoad <- function(lib, pkg) {
    dlp<-Sys.getenv("DYLD_LIBRARY_PATH")
    if (dlp!="") { # for Mac OS X we need to remove X11 from lib-path
        Sys.setenv("DYLD_LIBRARY_PATH"=sub("/usr/X11R6/lib","",dlp))
    }
    jars <- list.files(path=paste(lib,pkg,"cont", sep=.Platform$file.sep),
                       pattern="jar$", full.names=TRUE)
    .jinit(classpath=c(jars))
}
    

