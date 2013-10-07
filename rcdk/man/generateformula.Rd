\name{generate.formula}
\alias{generate.formula}
\title{
	Generate a cdkFormula object.
}
\description{
	This function generate a list of \code{cdkFormula} objects given a mass.
}
\usage{
generate.formula(mass, window=0.01, elements=list(c("C",0,50),c("H",0,50),
                                                  c("N",0,50),c("O",0,50),
                                                  c("S",0,50)),
                 validation=FALSE, charge=0.0)
}

\arguments{
  \item{mass}{The mass value from which to be generate the formulas.},
  \item{window}{The window accuracy in the same units as mass.},
  \item{elements}{Elements to take into account.},
  \item{validation}{TRUE, if the method should only generate valid
  formulas. If FALSE, nonsensical formulae my be generated which must
  be filtered out by the user},
  \item{charge}{The charge value of the formula.}
 }
\value{
	Objects of class MassToFormulaTool, from the \code{IMolecularFormula} package
}
\examples{
mfSet <- generate.formula(18.03383,charge=1,
                          elements=list(c("C",0,50),c("H",0,50),c("N",0,50)))
for (i in mfSet) {
  print(i)
}
}
\keyword{programming}
\seealso{
  \code{\link{get.formula}},
  \code{\link{set.charge.formula}},
  \code{\link{get.isotopes.pattern}},
  \code{\link{isvalid.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
