\name{fp.to.matrix}
\alias{fp.to.matrix}
\title{
  Converts a List of Fingerprints to a Matrix
}
\description{
    In general, fingerprint data is read from a file or obtained via
    calls to an external generator and the return value is a list of fingerprints.
    This function takes the list and returns a matrix having number of rows equal to 
    the number of fingerprints and the number of columns equal to the length of
    the fingerprint. Each element is 1 or 0 (1's being specified by the positions
    in each fingerprint vector)
}
\usage{
fp.to.matrix(fplist)
}
\arguments{
    \item{fplist}{
        A list structure with each element being an object of class
	\code{fingerprint}. These will can be constructed by hand or
	read from disk via \code{\link{fp.read}}
    }
}
\value{
A matrix with dimensions equal to \code{length(fplist), bit length)}
where bit length is a property of the fingerprint objects in the list.
}
\seealso{
    \code{\link{distance}}, \code{\link{fp.read}}
}
\examples{
# make fingerprint objects
fp1 <- new("fingerprint", nbit=6, bits=c(1,2,5,6))
fp2 <- new("fingerprint", nbit=6, bits=c(1,4,5,6))
fp3 <- new("fingerprint", nbit=6, bits=c(2,3,4,5,6))

fp.to.matrix( list(fp1,fp2,fp3) )
}
\keyword{logic}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
