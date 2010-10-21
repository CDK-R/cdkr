\name{as.character}
\alias{as.character}
\alias{as.character,fingerprint-method}
\alias{as.character,featvec-method}
\title{
  Generates a String Representation of a Fingerprint
}
\description{
    The function returns a string of 1's and 0's or a character vector of
    features depending on the nature of the fingerprint supplied.        
}
\usage{
\S4method{as.character}{fingerprint}(x)
\S4method{as.character}{featvec}(x)
}
\arguments{
    \item{x}{
      An object of class \code{fingerprint} or \code{featvec}
    }
}
\value{
A string of 1's and 0's or else a character vector of features
}

\examples{
# make a fingerprint vector
fp <- new("fingerprint", nbit=32, bits=sample(1:32, 20))

# print out the string representation
as.character(fp)
}
\keyword{logic}
\keyword{methods}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
