setClass("fingerprint",
         representation(bits="numeric",
                        nbit="numeric",
                        folded="logical",
                        provider="character",
                        name="character"),
         validity=function(object) {
           if (any(object@bits > object@nbit))
             return("Bit positions were greater than the specified bit length")
           else return(TRUE)           
         },
         prototype(bits=c(),
                   nbit=0,
                   folded=FALSE,
                   provider="",
                   name=""))

#setGeneric("show", function(object) standardGeneric("show"))
setMethod("show", "fingerprint",
          function(object) {
            cat("Fingerprint object\n")
            cat(" name = ", object@name, "\n")
            cat(" length = ", object@nbit, "\n")
            cat(" folded = ", object@folded, "\n")
            cat(" source = ", object@provider, "\n")
            cat(" bits on = ", paste(sort(object@bits), collapse=' '), "\n")
          })


setMethod('as.character', "fingerprint",
          function(x) {
            s <- numeric(x@nbit)
            s[x@bits] <- 1
            paste(s,sep='',collapse='')
          })

setMethod("length", "fingerprint",
          function(x) {
            x@nbit
          })

parseCall <- function (obj) 
{
    if (class(obj) != "call") {
        stop("Must supply a 'call' object")
    }
    srep <- deparse(obj)
    if (length(srep) > 1) 
        srep <- paste(srep, sep = "", collapse = "")
    fname <- unlist(strsplit(srep, "\\("))[1]
    func <- unlist(strsplit(srep, paste(fname, "\\(", sep = "")))[2]
    func <- unlist(strsplit(func, ""))
    func <- paste(func[-length(func)], sep = "", collapse = "")
    func <- unlist(strsplit(func, ","))
    vals <- list()
    nms <- c()
    cnt <- 1
    for (args in func) {
        arg <- unlist(strsplit(args, "="))[1]
        val <- unlist(strsplit(args, "="))[2]
        arg <- gsub(" ", "", arg)
        val <- gsub(" ", "", val)
        vals[[cnt]] <- val
        nms[cnt] <- arg
        cnt <- cnt + 1
    }
    names(vals) <- nms
    vals
}
