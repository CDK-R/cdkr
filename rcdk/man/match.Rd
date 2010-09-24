\name{matches}
\alias{match}
\alias{matches}
\alias{smarts}
\alias{substructure}
\alias{is.subgraph}
\alias{get.mcs}
\title{
  Perform Substructure Searching & MCS Detection	
}
\description{
These functions perform substructure searches of a query, specified
in SMILES or SMARTS forms, over one or more target molecules.
}
\usage{
matches(query, target) 
is.subgraph(query, target)
get.mcs(mol1, mol2, method = 'MCSPlus')
}
\arguments{
  \item{query}{A SMILES or SMARTS string}
  \item{target}{A single IAtomContainer object or a list of IAtomContainer objects}
  \item{mol1}{An IAtomContainer}
  \item{mol2}{An IAtomContainer}
}
\details{
For the case of \code{is.subgraph}, the target molecule must be a single 
\code{IAtomContainer} or a valid SMILES string. Note that this method can be 
significantly faster than \code{matches}, but is limited by the fact that SMARTS
patterns cannot be specified.
}
\examples{
smiles <- c('CCC', 'c1ccccc1', 'C(C)(C=O)C(CCNC)C1CC1C(=O)')
mols <- sapply(smiles, parse.smiles)
query <- '[#6]=O'
matches <- match(query, mols)
}
\value{
For \code{matches}, a boolean vector, where each element is TRUE or FALSE depending on whether
the corresponding element in targets contains the query or not.
}
\details{
Note that
since the CDK SMARTS matcher internally will perform aromaticity perception and
atom typing, the target molecules need not have these operations done on them 
beforehand. However, if \code{is.subgraph} is being used, the molecules should
have aromaticity detected and atom typing performed.
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
