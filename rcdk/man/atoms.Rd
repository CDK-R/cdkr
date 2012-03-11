\name{Atoms}
\alias{get.symbol}
\alias{get.point3d}
\alias{get.point2d}
\alias{get.atomic.number}
\alias{get.hydrogen.count}
\alias{get.charge}
\alias{get.formal.charge}
\alias{get.connected.atoms}
\alias{get.atom.index}
\alias{is.aromatic}
\alias{is.aliphatic}
\alias{is.in.ring}
\title{
	Operations on atoms
}
\description{
\code{get.symbol} returns the chemical symbol for an atom.

\code{get.point3d} returns the 3D coordinates of the atom

\code{get.point2d} returns the 2D coordinates of the atom

\code{get.atomic.number} returns the atomic number of the atom

\code{get.hydrogen.count} returns the number of implicit H's on the atom. 
Depending on where the molecule was read from this may be \code{NULL} or an integer
greater than or equal to 0

\code{get.charge} returns the partial charge on the atom. If charges have not been set the
return value is \code{NULL}, otherwise the appropriate charge.

\code{get.formal.charge} is returns the formal charge on the atom. By default the formal
charge will be 0 (i.e., \code{NULL} is never returned)

\code{is.aromatic} returns \code{TRUE} if the atom is aromatic, \code{FALSE} 
otherwise

\code{is.aliphatic} returns \code{TRUE} if the atom is part of an aliphatic chain, 
\code{FALSE} otherwise

\code{is.in.ring} returns \code{TRUE} if the atom is in a ring, \code{FALSE} 
otherwise

\code{get.atom.index} returns the index of the atom in the molecule (starting from 0)

\code{get.connected.atoms} returns a list of atoms that are connected to the specified atom
}
\usage{
get.symbol(atom)
get.point3d(atom)
get.point2d(atom)
get.atomic.number(atom)
get.hydrogen.count(atom)
get.charge(atom)
get.formal.charge(atom)
get.connected.atoms(atom, mol)
get.atom.index(atom, mol)
is.aromatic(atom)
is.aliphatic(atom)
is.in.ring(atom)
}
\arguments{
  \item{atom}{A \code{jobjRef} representing an IAtom object}
  \item{mol}{A \code{jobjRef} representing an IAtomContainer object}
}
\value{
	In the case of \code{get.point3d} the return value is a
	3-element vector containing the X, Y and Z coordinates of the
	atom. If the atom does not have 3D coordinates, it returns a
	vector of the form \code{c(NA,NA,NA)}. Similarly for
	\code{get.point2d}, in which case the return vector is of
	length 2.
}
\keyword{programming}
\seealso{
  \code{\link{get.atoms}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
