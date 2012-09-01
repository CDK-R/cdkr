
setGeneric("fold", function(fp) standardGeneric("fold"))
setMethod("fold", "fingerprint",
          function(fp) {
            size <- fp@nbit
            if (size %% 2 != 0) {
              stop('Need to supply a fingerprint of even numbered length')
            }
            bfp <- rep(FALSE, size)
            bfp[fp@bits] <- TRUE

            subfplen <- size/2
            
            b1 <- which(bfp[1:subfplen])
            b2 <- which(bfp[(subfplen+1):size])
            
            subfp1 <- new("fingerprint",
                          nbit=subfplen,
                          bits=b1,
                          provider="R");
            
            subfp2 <- new("fingerprint",
                          nbit=subfplen,
                          bits=b2,
                          provider="R")
            foldedfp <- subfp1 | subfp2
            foldedfp@folded <- TRUE
            return(foldedfp)
          })

setGeneric("euc.vector", function(fp) standardGeneric("euc.vector"))
setMethod("euc.vector", "fingerprint",
          function(fp) {
            coord <- rep(0,length(fp))
            coord[fp@bits] <- 1.0 / sqrt(length(fp))
            coord
          })


setGeneric("distance", function(fp1,fp2,method,a,b) standardGeneric("distance"))
setMethod("distance", c("featvec", "featvec", "missing", "missing", "missing"),
          function(fp1, fp2) {
            distance(fp1, fp2, "tanimoto" )
          })
setMethod("distance", c("featvec", "featvec", "character", "missing", "missing"),
          function(fp1, fp2, method=c("tanimoto", "dice", "robust")) {
            method <- match.arg(method)
            n1 <- length(fp1)
            n2 <- length(fp2)
            n12 <- length(intersect(fp1@features, fp2@features))
            if (method == 'tanimoto') {
              return(n12/(n1+n2-n12))
            } else if (method == "robust") {
              return(0.5 + 0.5 * n12 * n12 / (n1*n2))
            } else if (method == "dice") {
              return(2.0 * n12 / (n1+n2))
            }
          })

setMethod("distance", c("fingerprint", "fingerprint", "missing", "missing", "missing"),
          function(fp1,fp2) {
            distance(fp1,fp2,"tanimoto")
          })

setMethod("distance", c("fingerprint", "fingerprint", "character", "numeric", "numeric"),
          function(fp1, fp2, method="tversky", a, b) {
            if (!is.null(method) && !is.na(method) && method != "tversky") distance(fp1, fp2, method)
            if ( length(fp1) != length(fp2))
              stop("Fingerprints must of the same bit length")
            if (a < 0 || b < 0) stop("a and b must be positive")

            tmp <- fp1 & fp2
            xiy <- length(tmp@bits)

            tmp <- fp1 | fp2
            xuy <- length(tmp@bits)

            x <- length(fp1@bits)
            y <- length(fp2@bits)
            return( xiy / (a*x + b*y + (1-a-b)*xiy ) )
          })
setMethod("distance", c("fingerprint", "fingerprint", "character", "missing", "missing"),
          function(fp1,fp2, method=c('tanimoto', 'euclidean', 'mt',
                              'simple', 'jaccard', 'dice',
                              'russelrao', 'rodgerstanimoto','cosine',
                              'achiai', 'carbo', 'baroniurbanibuser',
                              'kulczynski2',
                              
                              'hamming', 'meanHamming', 'soergel',
                              'patternDifference', 'variance', 'size', 'shape',

                              'hamann', 'yule', 'pearson', 'dispersion',
                              'mcconnaughey', 'stiles',

                              'simpson', 'petke',
                              'stanimoto', 'seuclidean'
                              )) {

            if (method == 'tversky')
              stop("If Tversky metric is desired, must specify a and b")
            
            if ( length(fp1) != length(fp2))
              stop("Fingerprints must of the same bit length")
            
            method <- match.arg(method)
            n <- length(fp1)

            if (method == 'tanimoto') {
              f1 <- numeric(n)
              f2 <- numeric(n)
              f1[fp1@bits] <- 1
              f2[fp2@bits] <- 1
              sim <- 0.0
              ret <-  .C("fpdistance", as.double(f1), as.double(f2),
                         as.integer(n), as.integer(1),
                         as.double(sim),
                         PACKAGE="fingerprint")
              return (ret[[5]])
            } else if (method == 'euclidean') {
              f1 <- numeric(n)
              f2 <- numeric(n)
              f1[fp1@bits] <- 1
              f2[fp2@bits] <- 1
              sim <- 0.0
              ret <-  .C("fpdistance", as.double(f1), as.double(f1),
                         as.integer(n), as.integer(2),
                         as.double(sim),
                         PACKAGE="fingerprint")
              return (ret[[5]])
            }

            size <- n

            ## in A & B
            tmp <- fp1 & fp2
            c <- length(tmp@bits)

            ## in A not in B
            tmp <- (fp1 | fp2) & !fp2
            a <- length(tmp@bits)

            ## in B not in A
            tmp <- (fp1 | fp2) & !fp1
            b <- length(tmp@bits)

            ## not in A, not in B
            tmp <- !(fp1 | fp2)
            d <- length(tmp@bits)

            dist <- NULL

            ## Simlarity
            if (method == 'stanimoto') {
              dist <- c / (a+b+c)
            } else if (method == 'seuclidean') {
              dist <- sqrt((d+c) / (a+b+c+d))
            } else if (method == 'dice') {
              dist <- c / (.5*a + .5*b + c)
            } else if (method == 'mt') {
              t1 <- c/(size-d)
              t0 <- d/(size-c)
              phat <- ((size-d) + c)/(2*size)
              dist <- (2-phat)*t1/3 + (1+phat)*t0/3
            } else if (method == 'simple') {
              dist <- (c+d)/n
            } else if (method == 'jaccard') {
              dist <- c/(a+b+c)
            } else if (method == 'russelrao') {
              dist <- c/size
            } else if (method == 'rodgerstanimoto') {
              dist <- (c+d)/(2*a+2*b+c+d)
            } else if (method == 'cosine' || method == 'achiai' || method == 'carbo') {
              dist <- c/sqrt((a+c)*(b+c))
            } else if (method == 'baroniurbanibuser') {
              dist <- (sqrt(c*d)+c)/(sqrt(c*d)+a+b+c)
            } else if (method == 'kulczynski2') {
              dist <- .5*(c/(a+c)+c/(b+c))              
            }
            ## Dissimilarity
            else if (method == 'hamming') {
              dist <- a+b
            } else if (method == 'meanHamming') {
              dist <- (a+b)/(a+b+c+d)
            }else if (method == 'soergel') {
              dist <- (a+b)/(a+b+c)
            } else if (method == 'patternDifference') {
              dist <- (a*b)/(a+b+c+d)^2
            } else if (method == 'variance') {
              dist <- (a+b)/(4*n)
            } else if (method == 'size') {
              dist <-  (a-b)^2/n^2
            } else if (method == 'shape') {
              dist <- (a+b)/n-((a-b)/(n))^2
            }

            ## Composite
            else if (method == 'hamann') {
              dist <- (c+d-a-b)/(a+b+c+d)
            } else if (method == 'yule') {
              dist <-  (c*d-a*b)/(c*d+a*b)
            } else if (method == 'pearson') {
              dist <- (c*d-a*b)/sqrt((a+c)*(b+c)*(a+d)*(b+d))
            } else if (method == 'dispersion') {
              dist <- (c*d-a*b)/n^2
            } else if (method == 'mcconaughey') {
              dist <- (c^2-a*b)/((a+c)*(b+c))
            } else if (method == 'stiles') {
              dist <- log10(n*(abs(c*d-a*b)-n/2)^2/((a+c)*(b+c)*(a+d)*(b+d)))
            }

            ## Asymmetric
            else if (method == 'simpson') {
              dist <- c/min((a+c),(b+c))
            } else if (method == 'petke') {
              dist <- c/max((a+c),(b+c))
            }
            
            dist
          })

setGeneric("random.fingerprint",
           function(nbit, on) standardGeneric("random.fingerprint"))
setMethod("random.fingerprint", c("numeric", "numeric"),
          function(nbit, on) {
            if (nbit <= 0) stop("Bit length must be positive integer")
            if (on <= 0) stop("Number of bits to be set to 1 must be positive integer")            
            bits <- sample(1:nbit, size=on)
            new("fingerprint", nbit=nbit, bits=bits, provider="R", folded=FALSE)
          })
