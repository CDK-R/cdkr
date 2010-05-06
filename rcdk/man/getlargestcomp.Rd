\name{is.connected}
\alias{get.largest.component}
\alias{is.connected}
\title{
Get the Largest Component in a Disconnected Molecule
}
\description{
These methods allow one to check whether a molecule is fully connected or
else retrieve the largest disconnected component
}
\usage{
get.largest.component(mol)
is.connected(mol)
}
\arguments{
  \item{mol}{A \code{jObjRef} representing an IAtomContainer object}
}
\value{
For \code{get.largest.component}, if the input molecule has more than one disconnected component, the 
largest is returned. Otherwise, the molecule itself is returned.

For \code{is.connected}, TRUE if the molecule is fully connected, FALSE otherwise
}
\examples{
m <- parse.smiles("CC.CCCCCC.CCCC")
largest <- get.largest.component(m)
length(get.atoms(largest)) == 6
}
\keyword{programming}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
