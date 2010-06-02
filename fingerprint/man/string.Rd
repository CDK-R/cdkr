\name{as.character}
\alias{as.character}
\alias{as.character,fingerprint-method}
\title{
  Generates a String Representation of a Fingerprint
}
\description{
    The function returns a string of 1's and 0's corresponding to the 
    fingerprint object supplied        
}
\usage{
\S4method{as.character}{fingerprint}(x)
}
\arguments{
    \item{x}{
      An object of class \code{fingerprint}
    }
}
\value{
A string of 1's and 0's
}

\examples{
# make a fingerprint vector
fp <- new("fingerprint", nbit=32, bits=sample(1:32, 20))

# print out the string representation
as.character(fp)
}
\keyword{logic}
\keyword{methods}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
