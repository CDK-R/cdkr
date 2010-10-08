\name{get.murcko.fragments}
\alias{fragment}
\alias{get.exhaustive.fragments}
\alias{get.murcko.fragments}
\title{
  Molecule Fragmentation Methods
}
\description{
A variety of methods for fragmenting molecules are available ranging from
exhaustive, rings to more specific methods such as Murcko frameworks. Fragmenting a
collection of molecules can be a useful for a variety of analyses. In addition
fragment based analysis can be a useful and faster alternative to traditional 
clustering of the whole collection, especially when it is large.

Note that exhaustive fragmentation of large molecules (with many single bonds) can become
time consuming.
}
\usage{
get.murcko.fragments(mols, min.frag.size = 6, as.smiles = TRUE, single.framework = FALSE)
get.exhaustive.fragments(mols, min.frag.size = 6, as.smiles = TRUE)
}
\arguments{
\item{mols}{A molecule object or list of molecule objects. Each object should have a \code{jclass} of
\code{IAtomContainer}}
\item{min.frag.size}{The size of the smallest fragments to be considered}
\item{as.smiles}{If \code{TRUE}, the fragments are returned as SMILES strings, otherwise as
 \code{IAtomContainer} objects}
\item{single.framework}{If \code{TRUE}, then a single framework (i.e., the framework consisting of the
union of all ring systems and linkers) is returned for each molecule. Otherwise, all combinations
of ring systems and linkers are returned}
}
\examples{
mol <- parse.smiles('c1ccc(cc1)CN(c2cc(ccc2[N+](=O)[O-])c3c(nc(nc3CC)N)N)C')[[1]]
mf1 <- get.murcko.fragments(mol, as.smiles=TRUE, single.framework=TRUE)
mf1 <- get.murcko.fragments(mol, as.smiles=TRUE, single.framework=FALSE)
}
\value{
\code{get.murcko.fragments} returns a list with each element being a list with two elements: \code{rings} and
\code{frameworks}. Each of these elements is either a character vector of SMILES strings or a list of
\code{IAtomContainer} objects.
\code{get.exhaustive.fragments} returns a list of length equal to the number of input molecules. Each
element is a character vector of SMILES strings or a list of \code{IAtomContainer} objects.
}
\keyword{programming}
\seealso{
  \code{\link{load.molecules}},
  \code{\link{parse.smiles}},
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
