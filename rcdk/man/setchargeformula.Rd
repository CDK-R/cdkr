\name{set.charge.formula}
\alias{set.charge.formula}
\title{
	Set the charge to a cdkFormula object.
}
\description{
	This function set the charge to a \code{cdkFormula} object.
	It modifies as the \code{IMolecularFormula} Java object as the 
	its mass.
}
\usage{
formula <- set.charge.formula(formula, charge=-1)
}
\arguments{
  \item{formula}{A \code{cdkFormula} object.}
  \item{charge}{The value of the charge to set.}
 }
\value{
  None
}
\keyword{programming}
\seealso{
  \code{\link{get.formula}},
  \code{\link{get.isotopes.pattern}},
  \code{\link{isvalid.formula}},
  \code{\link{generate.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
\references{
  A parallel effort to expand the Chemistry Development Kit:
  \url{http://cdk.sourceforge.net}
}
