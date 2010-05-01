\name{get.properties}
\alias{get.properties}
\title{
Get All Property Values of a Molecule
}
\description{
	Returns a list of all the properties of a molecule. The names
	of the list are set to the property names
}
\usage{
get.properties(molecule)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer} or \code{IMolecule}}
}
\value{
A list of the property values, with names equal to the property
names. NULL property values are returned as NA
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
  \code{\link{set.property}},
  \code{\link{remove.property}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
