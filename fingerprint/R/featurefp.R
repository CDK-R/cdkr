setClass("nfeatvec",
         representation(features="numeric",
                        provider="character",
                        name="character"),
         validity=function(object) {
           return(TRUE)
         },
         prototype(features=c(),
                   provider="",
                   name=""))

setMethod('show', 'nfeatvec',
          function(object) {
            cat("Numeric feature fingerprint\n")
            cat(" name = ", object@name, "\n")
            cat(" source = ", object@provider, "\n")
            cat(" features = ", paste(sort(object@features), collapse=' '), "\n")
          })

setMethod('as.numeric', 'nfeatvec', function(x) {
  return(x@features)
})
setMethod("length", "nfeatvec",
          function(x) {
            length(x@features)
          })
