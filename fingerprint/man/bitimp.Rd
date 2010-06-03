\name{bit.importance}
\alias{bit.importance}
\title{
Evaluate the Discriminatory Power of Individual Bits in a Binary Fingerprint
}
\description{
This method evaluates the Kullback-Leibler (KL) divergence to rank the 
individual bits in a binary fingerprint in their ability to discriminate 
between database and active compounds. This method is implemented based on
Nisius and Bajorath and includes an m-estimate correction.
}
\usage{
bit.importance(actives, background)
}
\arguments{
\item{actives}{A list of fingerprints for the actives}
\item{background}{A list of fingerprints representing the background collection}
}
\value{
A numeric vector of length equal to the size of the fingerprints. Each element
of the vector is the KL divergence for the corresponding bit. If a bit position
is never set to 1 in any of the compounds from the actives and the background, then
the KL divergence for that position is undefined and \code{NA} is returned.
}
\seealso{
\code{\link{bit.spectrum}}
}
\references{
Nisius, B.; Bajorath, J.; \emph{ChemMedChem}, \bold{2010},
\emph{5}, 859-868.
}
\keyword{programming}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
