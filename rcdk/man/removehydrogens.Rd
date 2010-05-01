\name{remove.hydrogens}
\alias{remove.hydrogens}
\title{
  Remove Hydrogens from a Molecule
}
\description{
  This function generate a new \code{IAtomContainer} object in which the
  hydrogens have been removed. This can be useful for descriptor
  calculations.
}
\usage{
remove.hydrogens(molecule)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
}
\value{
  A \code{jobref} that refers to a \code{IAtomContainer} object
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
