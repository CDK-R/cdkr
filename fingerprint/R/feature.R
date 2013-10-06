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

## getters/setters
setGeneric("feature", function(object) standardGeneric("feature"))
setMethod("feature", "feature", function(object) object@feature)
setGeneric("feature<-", function(this, value) standardGeneric("feature<-"))
setReplaceMethod("feature", signature=signature("feature", "character"),
                 function(this, value) {
                   this@feature <- value
                   this
                 })

setGeneric("count", function(object) standardGeneric("count"))
setMethod("count", "feature", function(object) object@count)
setGeneric("count<-", function(this, value) standardGeneric("count<-"))
setReplaceMethod("count", signature=signature("feature", "numeric"),
                 function(this, value) {
                   this@count <- as.integer(value)
                   this
})

