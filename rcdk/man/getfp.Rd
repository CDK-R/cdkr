\name{get.fingerprint}
\alias{get.fingerprint}
\title{
  Evaluate Fingerprints
}
\description{
  This function evaluates fingerprints of a specified type for a set of molecules or
  a single molecule. Depending on the nature of the fingerprint,
  parameters can be specified. Currently five different fingerprints
  can be specified:
  \itemize{
  \item standard - Considers paths of a given length. The default is
  but can be changed. These are hashed fingerprints, with a
  default length of 1024
  \item extended - Similar to the standard type, but takes rings and
   atomic properties into account into account
  \item graph - Similar to the standard type by simply considers connectivity
  \item hybridization - Similar to the standard type, but only consider hybridization state
  \item maccs - The popular 166 bit MACCS keys described by MDL
  \item estate - 79 bit fingerprints corresponding to the E-State atom types described by Hall and Kier
  \item pubchem - 881 bit fingerprints defined by PubChem
  \item kr - 4860 bit fingerprint defined by Klekota and Roth
  \item shortestpath - A fingerprint based on the shortest paths between pairs of atoms and takes into account ring systems, charges etc.
  \item signature - A feature,count type of fingerprint, similar in nature to circular fingerprints, but based on the signature 
    descriptor
  \item circular - An implementation of the ECFP6 fingerprint
  \item substructure - Fingerprint based on list of SMARTS pattern. By default a set of functional groups is tested.
  }

  Depending on whether the input is a single \code{IAtomContainer}
  object, a list or single vector is returned. Each element of the list 
  is an S4 object of class \code{\link{fingerprint-class}} or \code{\link{featvec-class}}, 
  which can be manipulated with the fingerprint package.
}
\usage{
    get.fingerprint(molecule, type = 'standard', 
                    fp.mode = 'bit', depth=6, size=1024, substructure.pattern=character(),
                    verbose=FALSE)
}
\arguments{
  \item{molecule}{An \code{IAtomContainer} object that can be obtained
    by loading them from disk or drawing them in the editor.
  }
  \item{type}{The type of fingerprint. See description for possible values. The default is the standard
  binary fingerprint.}
  \item{fp.mode}{The type of fingerprint to return. Possible values are 'bit', 'raw', and 'count'. The 'raw' mode will  
  return a \code{featvec-class} type of fingerprint, representing fragments and their count of occurence in the molecule.
  The 'count' mode is similar, except that it returns hash values of fragments and their count of occurence.
  While any of these values can be specified, a given fingerprint implementation may not implement all of them, and in 
  those cases the return value is NULL.}
  \item{depth}{The search depth. This argument is ignored for the
  'pubchem', 'maccs', 'kr' and 'estate' fingerprints}
  \item{size}{The length of the fingerprint bit string. This argument is ignored for the
  'pubchem', 'maccs', 'kr', 'signature', 'circular' and 'estate' fingerprints}
  \item{substructure.pattern}{List of characters containing the SMARTS pattern to match. If the an empty list is provided
  than the functional groups substructures (default in CDK) are used.}
  \item{verbose}{If \code{TRUE}, exceptions, if they occur, will be printed}
}
\value{
  Objects of class \code{\link{fingerprint-class}} or \code{\link{featvec-class}}, from the \code{fingerprint} package. If there is a problem
  during fingerprint calculation, \code{NULL} is returned.
}
\examples{
## get some molecules
sp <- get.smiles.parser()
smiles <- c('CCC', 'CCN', 'CCN(C)(C)', 'c1ccccc1Cc1ccccc1','C1CCC1CC(CN(C)(C))CC(=O)CC')
mols <- parse.smiles(smiles)
 
## get a single fingerprint using the standard
## (hashed, path based) fingerprinter
fp <- get.fingerprint(mols[[1]])

## get MACCS keys for all the molecules
fps <- lapply(mols, get.fingerprint, type='maccs')

## get Signature fingerprint
## feature, count fingerprinter
fps <- lapply(mols, get.fingerprint, type='signature', fp.mode='raw')

## get Substructure fingerprint for functional group fragments
fps <- lapply(mols, get.fingerprint, type='substructure')

## get Substructure count fingerprint for user defined fragments
mol1 <- parse.smiles("c1ccccc1CCC")[[1]]
smarts <- c("c1ccccc1", "[CX4H3][#6]", "[CX2]#[CX2]")
fps <- get.fingerprint(mol1, type='substructure', fp.mode='count',
    substructure.pattern=smarts)
}      

\seealso{
  \code{\link{load.molecules}}
}

\references{
Faulon et al, \href{http://dx.doi.org/10.1021/ci020345w}{The Signature Molecular Descriptor. 1. Using Extended Valence Sequences in QSAR and QSPR studies}, \emph{J. Chem. Inf. Comput. Sci.}, 2003, \emph{43}, 707-720. 	
}

\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
