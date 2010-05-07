\name{Molecule}
\alias{get.exact.mass}
\alias{get.natural.mass}
\alias{convert.implicit.to.explicit}
\title{
	Operations on molecules
}
\description{
	Various functions to perform operations on molecules. 

	\code{get.exact.mass} returns the exact mass of a molecule

	\code{get.natural.mass} returns the natural exact mass of a molecule	

	\code{convert.implicit.explicit} converts implicit hydrogens
	to explicit hydrogens. This function does not return any value
	but rather modifies the molecule object passed to it
}
\usage{
get.exact.mass(molecule)
get.natural.mass(molecule)
convert.implicit.to.explicit(molecule)
}
\arguments{
  \item{molecule}{A \code{jObjRef} representing an IAtomContainer or IMolecule object}
}
\value{
	\code{exact.mass} returns a numeric

	\code{get.natural.mass} returns a numeric

	\code{convert.implicit.to.explicit} has no return value
}
\details{
In some cases, a molecule may not have any hydrogens (such as when read
in from an MDL MOL file that did not have hydrogens). In such cases, this method
will add implicit hydrogens and then convert them to explicit ones. In additio, for
such cases, make sure that the molecule has been typed beforehand.
}
\keyword{programming}
\seealso{
  \code{\link{get.atoms}}, \code{\link{do.typing}}
}
\examples{
  m <- parse.smiles('c1ccccc1')

  ## Need to configure the molecule
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)

  get.exact.mass(m)
  get.natural.mass(m)

  convert.implicit.to.explicit(m)
  get.natural.mass(m) 
  do.isotopes(m) # Configure isotopes of newly added hydrogens
  get.exact.mass(m)
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
