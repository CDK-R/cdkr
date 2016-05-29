test.Java.version <- function() {
  jversion <- .jcall("java/lang/System", "S", "getProperty", "java.runtime.version")
  jversionnumeric <- as.numeric(paste0(strsplit(jversion, "\\.")[[1]][1:2], collapse = "."))
  checkTrue(jversionnumeric >= 1.8)  
}
