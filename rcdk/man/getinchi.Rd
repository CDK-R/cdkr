\name{get.inchi}
\alias{get.inchi}
\alias{get.inchi.key}
\alias{inchi}
\title{
  Get the InChI or InChI Key for a Molecule
}
\description{
These methods generate the InChI or InChI key for an input molecule using the
default settings. Currently there is no way to provide options to the InChI 
generator.
}
\usage{
get.inchi(molecule)
get.inchi.key(molecule)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
}
\value{
  An R character object containing the InChI or InChI key
}
\examples{
sp <- get.smiles.parser()
smiles <- c('CCC', 'CCN', 'CCN(C)(C)', 'c1ccccc1Cc1ccccc1','C1CCC1CC(CN(C)(C))CC(=O)CC')
mols <- parse.smiles(smiles)
sapply(mols, get.inchi)
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
