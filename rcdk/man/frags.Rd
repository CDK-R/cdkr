\name{get.fragmenter}
\alias{fragment}
\alias{get.fragmenter}
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
}
\usage{
get.fragmenter()
get.murcko.fragments(mol, fragmenter, min.ring.size = 6, as.smiles = TRUE)
}
\arguments{
\item{mol}{A molecule object. It should be a \code{jobjRef} object with class
\code{IAtomContainer}}
\item{fragmenter}{A \code{jobjRef} representing the CDK fragmenter class, obtained 
via \code{get.fragmenter}}
\item{min.ring.size}{The size of the smallest rings to be considered}
\item{as.smiles}{If \code{TRUE}, the return value is a vector of SMILES strings
representing the fragments. Otherwise it is a \code{list} of \code{IAtomContainer}
objects}
}
\examples{
mol <- parse.smiles('c1ccc(cc1)CN(c2cc(ccc2[N+](=O)[O-])c3c(nc(nc3CC)N)N)C')
f <- get.fragmenter()
frags.mols <- get.murcko.fragments(mol, f, as.smiles=FALSE)
frags <- get.murcko.fragments(mol, f, as.smiles=TRUE)
}
\value{
\code{get.fragmenter()} returns an instance of \code{GenerateFragments} which is primarily
meant to be used as input to the specific fragmentation methods.

\code{get.murcko.fragments} returns a vector of SMILES strings if \code{as.smiles} 
is \code{TRUE} otherwise a \code{list} of \code{IAtomContainer} objects, representing
the individual fragments. The latter form is useful if you plan to manipulate the 
fragments in terms of their chemical structures (such as calculating descriptors and 
so on).
}
\keyword{programming}
\seealso{
  \code{\link{load.molecules}},
  \code{\link{parse.smiles}},
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
