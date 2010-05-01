\name{get.isotopes.pattern}
\alias{get.isotopes.pattern}
\title{
	Generate the isotope pattern.
}
\description{
	This function get the isotope pattern given a \code{cdkFormula} object.
	It modifies as the \code{IMolecularFormula} Java object as the 
	its mass.
}
\usage{
get.isotopes.pattern(formula,minAbund=0.1)
}
\arguments{
  \item{formula}{A \code{cdkFormula} object.}
  \item{minAbund}{Minimal abundance of the isotopes to be added in the combinatorial search.}
 }
\value{
	Objects of class IsotopePatternGenerator, from the \code{IMolecularFormula} package
}
\keyword{programming}
\seealso{
  \code{\link{get.formula}},
  \code{\link{set.charge.formula}},
  \code{\link{isvalid.formula}},
  \code{\link{generate.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
\references{
  A parallel effort to expand the Chemistry Development Kit:
  \url{http://cdk.sourceforge.net}
}
