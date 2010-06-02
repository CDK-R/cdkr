\name{fp.factor.matrix}
\alias{fp.factor.matrix}
\title{
  Converts a List of Fingerprints to a data.frame of Factors
}
\description{
This function will convert  a \code{list} of fingerprint objects
to a \code{data.frame} of factors with levels 1 and 0.
}
\usage{
fp.factor.matrix(fplist)
}
\arguments{
  \item{fplist}{
        A list structure with each element being an object of class
	\code{fingerprint}. These will can be constructed by hand or
	read from disk via \code{\link{fp.read}}    
    }
}
\value{
A matrix with dimensions equal to \code{(length(fplist), length(fplist))}
}
\seealso{
    \code{\link{distance}}, \code{\link{fp.read}}
}
\examples{
# make fingerprint objects
fp1 <- new("fingerprint", nbit=6, bits=c(1,2,5,6))
fp2 <- new("fingerprint", nbit=6, bits=c(1,4,5,6))
fp3 <- new("fingerprint", nbit=6, bits=c(2,3,4,5,6))

fp.factor.matrix( list(fp1,fp2,fp3) )
}
\keyword{logic}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
