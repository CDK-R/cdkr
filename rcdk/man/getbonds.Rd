\name{get.bonds}
\alias{get.bonds}
\title{
	Get the bonds from a molecule
}
\description{
	This function returns a list containing \code{IABond} objects
	from a molecule
}
\usage{
get.bonds(molecule)
}
\arguments{
  \item{molecule}{A \code{jObjRef} representing an IAtomContainer,
  IMolecule}
}
\value{
  A list containing \code{jobjRef}'s to a CDK \code{IBond} object
}
\keyword{programming}
\seealso{
  \code{\link{get.atoms}},
  \code{\link{get.connected.atom}},
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
