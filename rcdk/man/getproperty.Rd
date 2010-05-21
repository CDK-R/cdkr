\name{get.property}
\alias{get.property}
\title{
  Get the Value of a Molecule Property
}
\description{
  This function retrieves the value of a keyed property that has
  previously been set on the molecule
}
\usage{
get.property(molecule, key)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
  \item{key}{A string naming the property}
}
\value{
 The value of the property is the key is found else NA
}
\examples{
smiles <- 'c1ccccc1'
mol <- parse.smiles(smiles)[[1]]
set.property(mol, 'prop1', 23.45)
set.property(mol, 'prop2', 'inactive')
get.property(mol, 'prop1')
}
\keyword{programming}
\seealso{
 \code{\link{get.properties}},
  \code{\link{set.property}},
  \code{\link{remove.property}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
