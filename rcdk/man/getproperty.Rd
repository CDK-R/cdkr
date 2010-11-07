\name{get.property}
\alias{get.property}
\alias{get.title}
\title{
  Get the Value of a Molecule Property
}
\description{
  This function retrieves the value of a keyed property that has
  previously been set on the molecule.
  
  The \code{get.title} function is simply a wrapper around
  \code{get.property} that directly provides access to the molecule
  title.
}
\usage{
get.property(molecule, key)
get.title(molecule)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
  \item{key}{A string naming the property}
}
\value{
 The value of the property is the key is found else NA. For
  \code{get.title}, the title of the molecule if available otherwise NA
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
