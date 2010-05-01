\name{do.aromaticity}
\alias{do.aromaticity}
\alias{do.typing}
\alias{do.isotopes}
\title{
Perform Aromaticity Detection, atom typing or isotopic configuration
}
\description{
These methods can be used to perform aromaticity detection, atom
typing or isotopic configuration on a molecule object. In general, when molecules are
loaded via \code{\link{load.molecules}} these are performed by
default. If molecules are obtained via \code{\link{parse.smiles}}
these operations are not performed and so the user should call one or
both of these methods to corrrectly configure a molecule.
}
\usage{
do.aromaticity(molecule)
do.typing(molecule)
do.isotopes(molecule)
}
\arguments{
  \item{molecule}{The molecule on which the operation is to be
  performed. Should of class \code{jobjRef} with a \code{jclass}
  attribute of \code{IAtomContainer}}
}
\value{
 No return value. If the operations fail an exception is thrown and an
 error message is printed
}
\keyword{programming}
\seealso{
  \code{\link{load.molecules}},
  \code{\link{parse.smiles}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
