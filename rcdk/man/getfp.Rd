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
  \item estate - 79 bit fingerprints corresponding to the E-State atom
  types described by Hall and Kier
  \item pubchem - 881 bit fingerprints defined by PubChem
  \item kr - 4860 bit fingerprint defined by Klekota and Roth
  \item shortestpath - A fingerprint based on the shortest paths between pairs of atoms and takes into account ring systems, charges etc.
  }

  Depending on whether the input is a single \code{IAtomContainer}
  object, a list or single vector is returned. Each element of the list 
  is an S4 object of class \code{fingerprint}, which can be
  manipulated with the fingerprint package.
}
\usage{
    get.fingerprint(molecule, type = 'standard', depth=6, size=1024, verbose=FALSE)
}
\arguments{
  \item{molecule}{An \code{IAtomContainer} object that can be obtained
    by loading them from disk or drawing them in the editor.
  }
  \item{type}{The type of fingerprint. Alternatives include
  'extended',  'graph', 'maccs', 'estate', 'hybridization'} 
  \item{depth}{The search depth. This argument is ignored for the
  'pubchem', 'maccs' and 'estate' fingerprints}
  \item{size}{The length of the fingerprint bit string. This argument is ignored for the
  'pubchem', 'maccs' and 'estate' fingerprints}
  \item{verbose}{If \code{TRUE}, exceptions, if they occur, will be printed}
}
\value{
  Objects of class fingerprint, from the \code{fingerprint} package. If there is a problem
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
}      
\seealso{
  \code{\link{load.molecules}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
