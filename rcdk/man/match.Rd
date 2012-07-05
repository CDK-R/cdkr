\name{matches}
\alias{match}
\alias{matches}
\alias{smarts}
\alias{substructure}
\alias{is.subgraph}
\alias{get.mcs}
\alias{mcs}
\title{
  Perform Substructure Searching & MCS Detection	
}
\description{
These functions perform substructure searches of a query, specified
in SMILES or SMARTS forms, over one or more target molecules and maximum
common substructure searches for pairs of molecules.
}
\usage{
matches(query, target, return.matches=FALSE) 
is.subgraph(query, target)
get.mcs(mol1, mol2, as.molecule = TRUE)
}
\arguments{
  \item{query}{A SMILES or SMARTS string}
  \item{target}{A single IAtomContainer object or a list of IAtomContainer objects}
  \item{mol1}{An IAtomContainer}
  \item{mol2}{An IAtomContainer}
  \item{return.matches}{If \code{TRUE} the lists of atom indices that correspond to the matching substructure are returned}
  \item{as.molecule}{If \code{TRUE} the MCS is returned as a new \code{IAtomContainer}
  object. Otherwise a atom index maping between the two molecules is returned as a 2D
  array of integers}
}
\details{
For the case of \code{is.subgraph}, the query molecule must be a single 
\code{IAtomContainer} or a valid SMILES string. Note that this method can be 
significantly faster than \code{matches}, but is limited by the fact that SMARTS
patterns cannot be specified. This uses the "TurboSubStructure" SMSD method and so
only searches for the first substructure match.

For MCS detection, the default SMSD algorithm is employed and the best scoring MCS is
returned by default. Furthermore, one can obtain the resultant MCS either as an \code{
IAtomContainer} in which the atoms and bonds are clones of the corresponding matching
atoms and bonds in one of the molecule. Or else as a 2D array of dimensions Nx2 of
atom index mappings. Here N is the size of the MCS and the first column represents the 
atom index from the first molecule and the second column the atom index from the second
molecule.

Note that since the CDK SMARTS matcher internally will perform aromaticity perception and
atom typing, the target molecules need not have these operations done on them 
beforehand for \code{matches} method. However, if \code{is.subgraph} or \code{get.mcs}
 is being used, the molecules should have aromaticity detected and atom typing performed
explicitly.

If the atom indices of the matching substructures (in the target molecule) are desired, use the
\code{matches} function directly.
}
\examples{
smiles <- c('CCC', 'c1ccccc1', 'C(C)(C=O)C(CCNC)C1CC1C(=O)')
mols <- sapply(smiles, parse.smiles)
query <- '[#6]=O'
doesMatch <- matches(query, mols)

## get mappings
mappings <- matches("CCC", mols, TRUE)
}
\value{
For \code{matches} with \code{return.matches = FALSE}, a boolean vector where each element is \code{TRUE} or \code{FALSE} depending on whether 
the corresponding element in targets contains the query or not. If \code{return.matches = TRUE}, the return value
is a list of lists. The number of elements of the top level list equals the number of matches. Each element is a list of two elements, named
"match" and "mapping". The first element is \code{TRUE} if the query matched the target. If so, the second element is a list of numeric
vectors, giving the atom indices (0-indexed) of the target atoms that matched the query. If there was no match for this target molecule, this
element will be \code{NULL}

For \code{is.subgraph}, a boolean vector, where each element is TRUE or
 FALSE depending on whether the corresponding element in targets contains the query or not.

For \code{get.mcs} an \code{IAtomContainer} object or a 2D array of atom index mappings
between the two molecules.
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
