\name{get.mol2formula}
\alias{get.mol2formula}
\title{
	Parser a molecule to formula object.
}
\description{
	This function convert a molecule object to a formula object.
}
\usage{
get.mol2formula(molecule, charge=0)
}

\arguments{
  \item{molecule}{The molecule to be parsed.},
  \item{charge}{The charge characterizing the molecule.},
}
\value{
	Objects of class MolecularFormulaManipulator, from the \code{IMolecularFormulaManipulator} package
}
\examples{
sp <- get.smiles.parser()
molecule <- sapply('N', parse.smiles, parser=sp)[[1]]
convert.implicit.to.explicit(molecule)
formula <- get.mol2formula(molecule,charge=0)
}
\keyword{programming}
\seealso{
  \code{\link{set.charge.formula}},
  \code{\link{get.isotopes.pattern}},
  \code{\link{isvalid.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
