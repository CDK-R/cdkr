\name{matches}
\alias{match}
\alias{matches}
\alias{smarts}
\title{
  Perform Substructure Searching	
}
\description{
This function performs substructure searches of a query, specified
in SMILES or SMARTS forms, over one or more target molecules.
}
\usage{
matches(query, targets) 
}
\arguments{
  \item{query}{A SMILES or SMARTS string}
  \item{targets}{A single IAtomContainer object or a list of IAtomContainer objects}
}
\examples{
smiles <- c('CCC', 'c1ccccc1', 'C(C)(C=O)C(CCNC)C1CC1C(=O)')
mols <- sapply(smiles, parse.smiles)
query <- '[#6]=O'
matches <- match(query, mols)
}
\value{
A boolean vector, where each element is TRUE or FALSE depending on whether
the corresponding element in targets contains the query or not.
}
\details{
Note that
since the CDK SMARTS matcher internally will perform aromaticity perception and
atom typing, the target molecules need not have these operations done on them 
beforehand.
}
\keyword{programming}
\seealso{
  \code{\link{load.molecules}},
  \code{\link{get.smiles}},
  \code{\link{do.aromaticity}},
  \code{\link{do.typing}},
  \code{\link{do.isotopes}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
