\name{isvalid.formula}
\alias{isvalid.formula}
\title{
	Validate a cdkFormula object.
}
\description{
	This function validates a \code{cdkFormula} object. At the moment
	is using the nitrogen Rule and RDBE Rule.
}
\usage{
isvalid.formula(formula, rule = c("nitrogen","RDBE"))
}
\arguments{
  \item{formula}{A \code{cdkFormula} object.}
  \item{rule}{The rules to be applied: nitrogen and RDBE.}
}
\value{
	Objects of class MolecularFormulaChecker, from the \code{IMolecularFormula} package
}
\examples{
formula <- get.formula('NH4', charge = 0)
isvalid.formula(formula, rule = c("nitrogen","RDBE"))
}
\keyword{programming}
\seealso{
  \code{\link{get.formula}},
  \code{\link{set.charge.formula}},
  \code{\link{get.isotopes.pattern}},
  \code{\link{generate.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
\references{
  A parallel effort to expand the Chemistry Development Kit:
  \url{http://cdk.sourceforge.net}
}
