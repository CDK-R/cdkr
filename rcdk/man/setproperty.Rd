\name{set.property}
\alias{set.property}
\title{
  Set A Property On A Molecule
}
\description{
  This function allows one to add a keyed property to a molecule. The
  key must be a string, but the value can be string, numeric or even an
  arbitrary Java object (of class \code{jobjRef})
}
\usage{
set.property(molecule, key, value)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
  \item{key}{A string naming the property}
  \item{value}{The value of the property. This can be character,
    integer, double or of class \code{jobjRef}}
}
\value{
  None
}
\examples{
smiles <- 'c1ccccc1'
mol <- parse.smiles(smiles)
set.property(mol, 'prop1', 23.45)
set.property(mol, 'prop2', 'inactive')
get.properties(mol)
}
\keyword{programming}
\seealso{
  \code{\link{get.property}},
  \code{\link{get.properties}},
  \code{\link{remove.property}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
