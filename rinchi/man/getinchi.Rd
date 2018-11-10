\name{get.inchi}
\alias{get.inchi}
\alias{get.inchi.key}
\title{
  Get the InChI or InChI Key for a Molecule
}
\description{
These methods generate the InChI or InChI key for an input molecule (either a 
molecule object obtained via \code{rcdk} or else a SMILES string) using the
default settings. Currently there is no way to provide options to the InChI 
generator.
}
\usage{
get.inchi(molecule)
get.inchi.key(molecule)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer} or else a character variable in which case
it is expected that it is a valid SMILES string}
}
\value{
  An R character object containing the InChI or InChI key
}
\examples{
smiles <- c('CCC', 'CCN', 'CCN(C)(C)', 'c1ccccc1Cc1ccccc1','C1CCC1CC(CN(C)(C))CC(=O)CC')
sapply(smiles, get.inchi)
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
