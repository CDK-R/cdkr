fp.sim.matrix <- function(fplist, fplist2=NULL, method='tanimoto') {

  sim <- NA
  
  if (!is.null(fplist2)) {
      sim <- do.call('rbind', lapply(fplist,
                                     function(fp) unlist(lapply(fplist2,
                                                                function(x) distance(x,fp, method=method)))))
      diag(sim) <- 1.0
      return(sim)
  }

  if (method == 'dice') {
    sim <- .dice.sim.mat(fplist)
  } else if (method == 'tanimoto') {
    sim <- .tanimoto.sim.mat(fplist)
  } else {
    sim <- matrix(0,nrow=length(fplist), ncol=length(fplist))
    for (i in 1:(length(fplist)-1)) {
      v <- unlist(lapply( fplist[(i+1):length(fplist)], distance, fp2=fplist[[i]], method=method))
      sim[i,(i+1):length(fplist)] <- v
      sim[(i+1):length(fplist),i] <- v
    }
  }
  diag(sim) <- 1.0
  return(sim)
}

## Takes the fingerprints, P bits,  for a set of N molecules supplied as
## a list structure and creates an N x P matrix
fp.to.matrix <- function( fplist ) {
  size <- fplist[[1]]@nbit
  m <- matrix(0, nrow=length(fplist), ncol=size)
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

.dice.sim.mat <- function(fplist) {
  m <- fp.to.matrix(fplist)
  mat<-m%*%t(m)
  len<-length(m[,1])
  s<-mat.or.vec(len,len)
  rs<-rowSums(m) #since its is binary just add the row values.

  for (i in 1:(len-1)) {
    for (j in (i+1):len) {
      s[i,j]=(2*(mat[i,j])/(rs[i]+rs[j]))
      s[j,i]=s[i,j]
    }
  }
  diag(s) <- 1.0  
  return(s)
}

.tanimoto.sim.mat <- function(fplist){
  m <- fp.to.matrix(fplist)
  mat<-m%*%t(m)
  len<-length(m[,1])
  s<-mat.or.vec(len,len)
  
  ret <-  .C("m_tanimoto", as.double(mat), as.integer(len), as.double(s),
             PACKAGE="fingerprint")
  ret <- matrix(ret[[3]], nrow=len, ncol=len, byrow=TRUE)
  return(ret)
  
  ## for (i in 1:len){
  ##   for (j in 1:len){
  ##     s[i,j]<- mat[i,j]/(mat[i,i]+mat[j,j]-mat[i,j]) # Formula for Tanimoto Calculation
  ##   }
  ## }
  ## return(s)
}
