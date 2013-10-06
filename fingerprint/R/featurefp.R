## Define a feature and its count
setClass("feature",
         contains = 'integer',
         representation(feature='character',
                        count='integer'),
         validity=function(object) {
           if (is.na(object@feature) || is.null(object@feature)) return("feature must be a string")
           if (object@count < 0) return("count must be zero or a positive integer")
           return(TRUE)
         },
         prototype(feature='', count=as.integer(1))
         )
setMethod('show', 'feature',
          function(object) {
            cat(sprintf('%s:%d', object@feature, object@count), '\n')
          })
setMethod('as.character', signature(x='feature'), function(x) sprintf("%s:%d", x@feature, x@count))
setMethod('c', signature(x='feature'), function(x, ...) {
  elems <- list(x, ...)
  ret <- list()
  for (i in seq_along(elems)) {
    ret[[i]] <- new("feature", feature=elems[[i]]@feature, count=as.integer(elems[[i]]@count))
  }
  return(ret)
})

## A feature fingerprint will be a vector of feature objects
setClass("featvec",
         representation(features="list",
                        provider="character",
                        name="character"),
         validity=function(object) {
           ## features must be a list of feature objects
           klasses <- unique(sapply(object@features, class))
           if (length(klasses) != 1 || klasses != 'feature')
             return("Must supply a list of 'feature' objects")
           iss4s <- sapply(object@features, isS4)
           if (!all(iss4s))
             return("Must supply a list of 'feature' objects")
           return(TRUE)
         },
         prototype(features=list(),
                   provider="",
                   name=""))

setMethod('show', 'featvec',
          function(object) {
            cat("Feature fingerprint\n")
            cat(" name = ", object@name, "\n")
            cat(" source = ", object@provider, "\n")
            cat(" features = ", paste(sapply(object@features, as.character), collapse=' '), "\n")
          })
setMethod('as.character', 'featvec', function(x) {
  return(paste(sapply(x@features, as.character), collapse=' '))
})
setMethod("length", "featvec", function(x) {
  length(x@features)
})

## featvec.to.binaryfp <- function(fps, bit.length = 256) {
##   if (!all(sapply(fps, class) == 'featvec'))
##     stop("Must supply a list of feature vector fingerprints")
##   ## get all the features
##   features <- sort(unique(unlist(lapply(fps, as.numeric))))
##   nbit <- length(features)
##   if (nbit %% 2 == 1) nbit <- nbit + 1
##   ## based on the entire feature set, convert original fps to binary fps
##   fps <- lapply(fps, function(x) {
##     bitpos <- match(as.numeric(x), features)
##     new("fingerprint", nbit=nbit, folded=FALSE, provider=x@provider,name=x@name, bits=bitpos)
##   })
##   return(fps)
## }

