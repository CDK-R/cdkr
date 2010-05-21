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
get.smiles(molecule)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
}
\value{
  An R character object containing the SMILES
}
\examples{
sp <- get.smiles.parser()
smiles <- c('CCC', 'CCN', 'CCN(C)(C)', 'c1ccccc1Cc1ccccc1','C1CCC1CC(CN(C)(C))CC(=O)CC')
mols <- parse.smiles(smiles)
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
