# R wrapper for the C implementation of stochastic proximity embedding.
#
# References: PNAS, 2002, vol 99, no 25, pg 15869
#             J. Comp. Chem. 2003, 24, 1215
#             J. Chem. Inf. Comp. Sci. 2003, 43, 475
#
# Rajarshi Guha <rajarshi@presidency.com>
# 22/04/04
#



spe <- function( 
coord, 
rcutpercent = 1, maxdist = 0, 
nobs = 0, ndim = 0, edim,
lambda0 = 2.0, lambda1 = 0.01,
nstep = 1e6, ncycle = 100, 
evalstress=FALSE, sampledist=TRUE, samplesize = 1e6) {

    stress <- 0
    coord <- as.matrix(coord)

    # get input dimension and observations if not supplied
    if (nobs == 0) {
        nobs = nrow(coord)
    }
    if (ndim == 0) {
        ndim = ncol(coord)
    }

    # do we need to obtain a maximum distance?
    if (sampledist && maxdist == 0) {
        maxdist <- sample.max.distance(coord, nobs, ndim, samplesize)
    }

    # evaluate the neighborhood radius from the max distance found
    if (rcutpercent == 0) {
        rcut <- maxdist
    }
    else {
        rcut <-  maxdist * rcutpercent
    }
        
    # set up the returned embedding matrix
    finalx <- runif(nobs*edim)

    # start the SPE
    retlist <- .C("spe", PACKAGE="spe",
    as.double(coord), as.double(rcut),
    as.integer(nobs), as.integer(ndim), as.integer(edim),
    as.double(lambda0), as.double(lambda1),
    as.integer(nstep), as.integer(ncycle),
    finalx = as.double(finalx))
    x <- matrix(retlist[[10]], nr=nobs, nc=edim)

    # do we need to evaluate the stress?
    if (evalstress) {
        stress <- eval.stress(x, coord, ndim, edim, nobs, samplesize)
        list(stress=stress,x=x)
    }
    else {
        list(x=x)
    }
}

eval.stress <- function(x,coord,ndim=0,edim=0,nobs=0,samplesize=1e6) {
    stress <- 0
    
    coord <- as.matrix(coord)
    x <- as.matrix(x)

    if (nobs == 0) {
        nobs = nrow(coord)
    }
    if (ndim == 0) {
        ndim = ncol(coord)
    }
    if (edim == 0) {
        edim = ncol(x)
    }

    retlist <- .C("eval_stress", PACKAGE="spe",
    as.double(x), as.double(coord), as.integer(ndim), as.integer(edim), as.integer(nobs),
    as.integer(samplesize),as.double(stress))
    retlist[[7]]
}

sample.max.distance <- function(coord, nobs = 0, ndim = 0, samplesize = 1e6) {
    maxdist <- 0
    coord <- as.matrix(coord)
    if (nobs == 0) {
        nobs = nrow(coord)
    }
    if (ndim == 0) {
        ndim = ncol(coord)
    }
    retlist <- .C("sample_distance", PACKAGE="spe",
    as.double(coord), 
    as.integer(nobs), as.integer(ndim), as.integer(samplesize),
    as.double(maxdist))
    retlist[[5]]
}
