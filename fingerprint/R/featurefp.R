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


## A feature fingerprint will be a vector of feature objects
setClass("featvec",
         representation(features="character",
                        provider="character",
                        name="character"),
         validity=function(object) {
           return(TRUE)
         },
         prototype(features=c(),
                   provider="",
                   name=""))

setMethod('show', 'featvec',
          function(object) {
            cat("Feature fingerprint\n")
            cat(" name = ", object@name, "\n")
            cat(" source = ", object@provider, "\n")
            cat(" features = ", paste(sort(object@features), collapse=' '), "\n")
          })

setMethod('as.character', 'featvec', function(x) {
  return(x@features)
})
setMethod("length", "featvec", function(x) {
  length(x@features)
})

featvec.to.binaryfp <- function(fps, bit.length = 256) {
  if (!all(unlist(lapply(fps, class)) == 'featvec'))
    stop("Must supply a list of feature vector fingerprints")
  ## get all the features
  features <- sort(unique(unlist(lapply(fps, as.numeric))))
  nbit <- length(features)
  if (nbit %% 2 == 1) nbit <- nbit + 1
  ## based on the entire feature set, convert original fps to binary fps
  fps <- lapply(fps, function(x) {
    bitpos <- match(as.numeric(x), features)
    new("fingerprint", nbit=nbit, folded=FALSE, provider=x@provider,name=x@name, bits=bitpos)
  })
  return(fps)
}

