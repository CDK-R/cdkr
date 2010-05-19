\name{get.atoms}
\alias{get.atoms}
\alias{get.atom.count}
\title{
	Get the atoms from a molecule or bond
}
\description{
	This function returns a list containing \code{IAtom} objects
	from a molecule or a bond.
}
\usage{
get.atoms(object)
get.atom.count(molecule)
}
\arguments{
  \item{object}{A \code{jObjRef} representing an \code{IAtomContainer},
  \code{IMolecule} or \code{IBond} object}
  \item{molecule}{A \code{jobjRef} representing an \code{IAtomContainer}}
}
\value{
  A list containing \code{jobjRef}'s to a CDK \code{IAtom} object or else
the number of atoms in the molecule
}
\keyword{programming}
\seealso{
  \code{\link{get.bonds}},
  \code{\link{get.point3d}},
  \code{\link{get.symbol}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
