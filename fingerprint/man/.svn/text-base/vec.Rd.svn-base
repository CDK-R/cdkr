\name{euc.vector}
\alias{euc.vector}
\title{
  Euclidean Representation of Binary Fingerprints
}
\description{
 Ordinarily, a binary fingerprint can be considered to represent a 
 corner of a nD hypercube. However in many cases using such a representation
 can lead to a very sparse space. Consequently one approach is to convert
 the fingerprint so that it represents points on a nD unit hypersphere.

 The resultant fingerprint is then a nD coordinate.
}
\usage{
euc.vector(fp)
}
\arguments{
    \item{fp}{
        An object of class \code{fingerprint}.
    }
}
\value{
A numeric of length equal to the bit length of the fingerprint. The
result corresponds to a unit vector for a point
on the nD hypersphere
}
\examples{
# make a fingerprint vector
fp <- new("fingerprint", nbit=8, bits=c(1,3,4,5,7))
vec <- euc.vector(fp)
}
\keyword{logic}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
