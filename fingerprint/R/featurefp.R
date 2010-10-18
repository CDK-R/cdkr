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

