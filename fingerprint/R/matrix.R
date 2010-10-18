fp.sim.matrix <- function(fplist, method='tanimoto') {
  fptype <- class(fplist[[1]])
  if ("fingerprint" %in% fptype) {
    size <- fplist[[1]]@nbit
    sim <- matrix(0,nr=length(fplist), nc=length(fplist))
    for (i in 1:(length(fplist)-1)) {
      v <- unlist(lapply( fplist[(i+1):length(fplist)], distance, fp2=fplist[[i]], method=method))
      sim[i,(i+1):length(fplist)] <- v
      sim[(i+1):length(fplist),i] <- v
    }
    diag(sim) <- 1.0
    sim
  } else {
    sim <- matrix(0,nr=length(fplist), nc=length(fplist))
    for (i in 1:(length(fplist)-1)) {
      v <- unlist(lapply( fplist[(i+1):length(fplist)], distance, fp2=fplist[[i]], method=method))
      sim[i,(i+1):length(fplist)] <- v
      sim[(i+1):length(fplist),i] <- v
    }
    diag(sim) <- 1.0
    sim
  }
}

## Takes the fingerprints, P bits,  for a set of N molecules supplied as
## a list structure and creates an N x P matrix
fp.to.matrix <- function( fplist ) {
  size <- fplist[[1]]@nbit
  m <- matrix(0, nr=length(fplist), nc=size)
  cnt <- 1
  for ( i in fplist ) {
    m[cnt,i@bits] <- 1
    cnt <- cnt + 1
  }
  m
}

fp.factor.matrix <- function( fplist ) {
  size <- fplist[[1]]@nbit
  m <- data.frame(fp.to.matrix(fplist))
  m[] <- lapply(m, factor, levels=0:1)
  m
}
