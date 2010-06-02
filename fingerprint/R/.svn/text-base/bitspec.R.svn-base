bit.spectrum <- function(fplist) {
  if (class(fplist) != 'list') stop("Must provide a list of fingerprint objects")
  if (any(unlist(lapply(fplist, class)) != 'fingerprint'))
    stop("Must provide a list of fingerprint objects");
  nbit <- length(fplist[[1]])
  spec <- numeric(nbit)
  for (i in 1:length(fplist)) {
    bits <- fplist[[i]]@bits
    spec[bits] <- spec[bits]+1
  }
  spec / length(fplist)
}
