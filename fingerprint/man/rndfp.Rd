\name{random.fingerprint}
\alias{random.fingerprint}
\title{
  Generate Randomized Fingerprints
}
\description{
  A utility function that can be used to generate binary fingerprints
  of a specified length with a specifed number of bit positions
  (selected randomly) set to 1. Currently bit positions are selected uniformly
}
\usage{
random.fingerprint(nbit,on)
}
\arguments{
    \item{nbit}{
      The length of the fingerprint, that is, the total number of bits.
      Must be a positive integer.
    }
    \item{on}{
      How many positions should be set to 1
      }
}
\value{
An object of class \code{fingerprint}
}
\examples{
# make a fingerprint vector
fp <- random.fingerprint(32, 16)
as.character(fp)
}
\keyword{logic}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
