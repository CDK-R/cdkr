.onLoad <- function(libname, pkgname) {
  assign(".rbiogrid.GlobalEnv", new.env(parent = emptyenv()), envir = topenv())
  assign("access.key", NULL, envir = .rbiogrid.GlobalEnv)
  assign("cache", list(), envir = .rbiogrid.GlobalEnv)
}

set.access.key <- function(key) assign("access.key", key, pos = .rbiogrid.GlobalEnv)
get.access.key <- function() {
  get("access.key", envir = .rbiogrid.GlobalEnv)
}

.set.cache <- function(key, val) {
  cache <- get("cache", envir = .rbiogrid.GlobalEnv)
  cache[[key]] <- val
  assign("cache", cache, pos = .rbiogrid.GlobalEnv)
}

.get.cache <- function(key) {
  cache <- get("cache", envir = .rbiogrid.GlobalEnv)
  return(cache[[key]])
}
