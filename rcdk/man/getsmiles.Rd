\name{get.smiles}
\alias{get.smiles}
\title{
  Get the SMILES for a Molecule
}
\description{
  The function will generate a SMILES representation of an
  IAtomContainer object. The default parameters of the CDK SMILES
  generator are used. This can mean that for large ring systems the
  method may fail. See CDK Javadocs for more information
}
\usage{
get.smiles(molecule, flavor = smiles.flavors(c('Generic')), smigen = NULL)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
  \item{flavor}{Customizations for SMILES generation. See \code{\link{smiles.flavors}}}
  \item{smigen}{An instance of \code{SmilesGenerator}, which can be useful if you are generating SMILES for a large number of molecules}
}
\seealso{
\code{\link{smiles.flavors}}, \code{\link{parse.smiles}}
}
\value{
  An R character object containing the SMILES
}
\examples{
m <- parse.smiles('C1C=CCC1N(C)c1ccccc1')[[1]]
get.smiles(m)
get.smiles(m, smiles.flavor(c('Generic','UseAromaticSymbols'))
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
