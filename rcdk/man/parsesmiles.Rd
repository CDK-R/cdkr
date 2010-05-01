\name{parse.smiles}
\alias{parse.smiles}
\title{
  Parse a SMILES String
}
\description{
  This function parses a SMILES string to generate an
  \code{IAtomContainer} object. Note that the resultant molecule will
  not have any 2D or 3D coordinates.

  Note that the molecules obtained from this method will not have any
  aromaticity perception, atom typing or isotopic configuration 
  done on them. This is in
  contrast to the \link{load.molecules} method. Thus, you should
  perform this steps manually on the molecules.
}
\usage{
parse.smiles(smiles, parser)
}
\arguments{
  \item{smiles}{A SMILES string}
  \item{parser}{A reference to an object of class
  \code{SmilesParser} that can be obtained from
  \code{\link{get.smiles.parser}}. If this argument is not specified,
  then a parser will be created automatically. However this is
  inefficient if you are parsing many SMILES. In such a case create
  your own parser and supply it as this argument}
}
\examples{
smiles <- c('CCC', 'c1ccccc1', 'C(C)(C=O)C(CCNC)C1CC1C(=O)')
mol <- parse.smiles(smiles[1])
mols <- lapply(smiles, parse.smiles)
}
\value{
  A \code{jobjRef} to a CDK \code{IAtomContainer} object. If the
  SMILES could not be parsed, \code{NA} is returned.
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
