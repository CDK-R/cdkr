\name{balance}
\alias{balance}
\title{
Generate a Balanced Code Fingerprint
}
\description{
It has been noted that the bit density in a fingerprint can affect its ability to
retrieve similar compounds from a database primarily due to complexity effects. One
approach to alleviating these effects is to generate fingerprints that have a bit
density of 50% (i.e., half the bits are set to 1). This method implements the 
balanced code approach described by Nisius and Bajorath to convert an ordinary
binary fingerprint (whose bit density is not 50%) to one that has a bit density of
50%. This is acheived by appending the complement of the input fingerprint to itself
(resulting in a fingerprint twice the size of the original).
}
\usage{
balance(fplist)
}
\arguments{
\item{fplist}{A single fingerprint or a list of fingerprints}
}
\value{
A single fingerprint objects or list of fingerprint objects that are "balanced",
in that they have a bit density of 50%. Their size is 2x the size of the input
fingerprints.
}
\seealso{
\code{\link{bit.spectrum}}, \code{\link{bit.importance}}
}
\references{
Nisius, B.; Bajorath, J.; \emph{ChemMedChem}, \bold{2010},
\emph{5}, 859-868.
}
\keyword{programming}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
