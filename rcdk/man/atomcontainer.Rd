\name{Molecule}
\alias{is.neutral}
\alias{convert.implicit.to.explicit}
\title{
	Operations on molecules
}
\description{
	Various functions to perform operations on molecules. 

	\code{convert.implicit.explicit} converts implicit hydrogens
	to explicit hydrogens. This function does not return any value
	but rather modifies the molecule object passed to it

	\code{is.neutral} returns \code{TRUE} if all atoms in the molecule
	have a formal charge of 0, otherwise \code{FALSE}
}
\usage{
convert.implicit.to.explicit(mol)
is.neutral(mol)
}
\arguments{
  \item{mol}{A \code{jObjRef} representing an IAtomContainer or IMolecule object}
}
\value{
	\code{convert.implicit.to.explicit} has no return value

	\code{is.neutral} returns a boolean.
}
\details{
In some cases, a molecule may not have any hydrogens (such as when read
in from an MDL MOL file that did not have hydrogens). In such cases, 
\code{\link{convert.implicit.to.explicit}} 
will add implicit hydrogens and then convert them to explicit ones. In addition, for
such cases, make sure that the molecule has been typed beforehand.
}
\keyword{programming}
\seealso{
  \code{\link{get.atoms}}, \code{\link{do.typing}}
}
\examples{
  m <- parse.smiles('c1ccccc1')[[1]]

  ## Need to configure the molecule
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)
  convert.implicit.to.explicit(m)
  is.neutral(m)
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
