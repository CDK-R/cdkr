setMethod("&", c("fingerprint", "fingerprint"),
          function(e1, e2) {
            if (e1@nbit != e2@nbit)
              stop("fp1 & fp2 must of the same bit length")
            
            andbits <- intersect(e1@bits, e2@bits)
            new("fingerprint",
                bits=andbits,
                nbit=e1@nbit,
                provider="R")
          })

setMethod("|", c("fingerprint", "fingerprint"),
          function(e1, e2) {
            if (e1@nbit != e2@nbit)
              stop("fp1 & fp2 must of the same bit length")
            
            orbits <- union(e1@bits, e2@bits)
            new("fingerprint",
                bits=orbits,
                nbit=e1@nbit,
                provider="R")
          })

setMethod("!", c("fingerprint"),
          function(x) {
            bs <- 1:(x@nbit)
            if (length(x@bits) > 0) b <- bs[ -x@bits ]
            else b <- bs
            ret <- new("fingerprint",
                       bits=b,
                       nbit=x@nbit,
                       provider="R")
            return(ret)
          })

setMethod("xor", c("fingerprint", "fingerprint"),
          function(x,y) {
            if (x@nbit != y@nbit)
              stop("e1 & e2 must of the same bit length")

            tmp1 <- rep(FALSE, x@nbit)
            tmp2 <- rep(FALSE, y@nbit)
            tmp1[x@bits] <- TRUE
            tmp2[y@bits] <- TRUE
            tmp3 <- xor(tmp1,tmp2)
            xorbits <- which(tmp3)
            
            new("fingerprint",
                bits=xorbits,
                nbit=x@nbit,
                provider="R")
          })

