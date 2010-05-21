\name{parse.smiles}
\alias{parse.smiles}
\title{
  Parse a Vector of SMILES Strings
}
\description{
  This function parses a vector of SMILES strings to generate a list of
  \code{IAtomContainer} objects. Note that the resultant molecule will
  not have any 2D or 3D coordinates.

  Note that the molecules obtained from this method will not have any
  aromaticity perception, atom typing or isotopic configuration 
  done on them. This is in
  contrast to the \link{load.molecules} method. Thus, you should
  perform these steps manually on the molecules.
}
\usage{
parse.smiles(smiles)
}
\arguments{
  \item{smiles}{A SMILES string}
}
\examples{
smiles <- c('CCC', 'c1ccccc1', 'C(C)(C=O)C(CCNC)C1CC1C(=O)')
mol <- parse.smiles(smiles[1])
mols <- parse.smiles(smiles)
}
\value{
  A list of \code{jobjRef}s to their corresponding CDK \code{IAtomContainer} objects. If a
  SMILES string could not be parsed, \code{NA} is returned instead.
}
\keyword{programming}
\seealso{
  \code{\link{load.molecules}},
  \code{\link{get.smiles}},
  \code{\link{get.smiles.parser}},
  \code{\link{view.molecule.2d}},
  \code{\link{do.aromaticity}},
  \code{\link{do.typing}},
  \code{\link{do.isotopes}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
