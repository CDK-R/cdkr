.onLoad <- function(libname, pkgname) {
  assign(".rbiogrid.GlobalEnv", new.env(parent = emptyenv()), envir = topenv())
  assign("access.key", NULL, envir = .rbiogrid.GlobalEnv)
  assign("cache", list(), envir = .rbiogrid.GlobalEnv)
}

#' Set your BioGRID access key to be used for subsequent queries
#' 
#' To query for interactions from BioGRID requires that each request
#' include an access key. You should get this when signing up. Set the
#' access key for this session using this function.
#'
#' @param key The users BioGRID access key 
#'
#' @keywords authentication
#' @export
set.access.key <- function(key) assign("access.key", key, pos = .rbiogrid.GlobalEnv)

#' Get your BioGRID access key 
#' 
#' Retrieve the current access key. If it has not been set, the access
#' key is \code{NULL}
#'
#' @return The users BioGRID access key
#' @keywords authentication
#' @export
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
