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

