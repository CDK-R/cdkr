\name{get.atoms}
\alias{get.atoms}
\title{
	Get the atoms from a molecule or bond
}
\description{
	This function returns a list containing \code{IAtom} objects
	from a molecule or a bond.
}
\usage{
get.atoms(object)
}
\arguments{
  \item{object}{A \code{jObjRef} representing an \code{IAtomContainer},
  \code{IMolecule} or \code{IBond} object}
}
\value{
  A list containing \code{jobjRef}'s to a CDK \code{IAtom} object
}
\keyword{programming}
\seealso{
  \code{\link{get.bonds}},
  \code{\link{get.point3d}},
  \code{\link{get.symbol}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
