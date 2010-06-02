
\name{fold}
\alias{fold}
\title{
  Fold a fingerprint
}
\description{
    In many situations a fingerprint is generated using a large length (such as 1024 bits or more).
    As a result of this, the fingerprints for a dataset can be very sparse. One approach to increasing 
    bit density of such fingerprints is to fold them. This is performed by dividing the original
    fingerprint bitstring into two substrings of equal length and then perform an OR on
    the two substrings. 

    It should be noted that many fingerprint generating routines will perform this internally.
}
\usage{
fold(fp)
}
\arguments{
    \item{fp}{
        The fingerprint to fold. Should be of class \code{fingerprint}.
    }
}
\value{
An object of class \code{fingerprint} representing the folded fingerprint.
}
\examples{
# make a fingerprint vector
fp <- new("fingerprint", nbit=64, bits=sample(1:64, 30))
fold(fp)
}
\keyword{logic}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
