\name{shannon}
\alias{shannon}
\alias{entropy}
\title{
Evaluate Shannon Entropy for a Set of Fingerprints
}
\description{
This method evaluates the Shannon entropy for a set of fingerprints
and utilizes the \code{\link{bit.spectrum}} method to obtain the relative
frequencies of individual bits
}
\usage{
shannon(fplist)
}
\arguments{
  \item{fplist}{
        A list structure with each element being an object of class
	\code{fingerprint}. These will can be constructed by hand or
	read from disk via \code{\link{fp.read}}.

	All fingerprints in the list should be of the same length.
    }
}
\value{
The Shannon entropy for the set of fingerprints
}
\seealso{
\code{\link{bit.spectrum}}, \code{\link{fp.read}}
}
\keyword{programming}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
