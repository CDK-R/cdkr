\name{get.formula}
\alias{get.formula}
\title{
	Get the formula object from a formula character.
}
\description{
	This function returns a formula object containing mass, 
	string character and isotopes when is given a character/string
	formula.
}
\usage{
get.formula(mf, charge=0)
}
\arguments{
  \item{mf}{A string containing the formula of the molecular formula of chemical object.}
  \item{charge}{The charge of the molecular formula.} 
}
\value{
	Objects of class \code{cdkFormula}, from the \code{IMolecularFormula} package
}
\examples{
formula <- get.formula('NH4', charge = 1)
formula
}
\keyword{programming}
\seealso{
  \code{\link{set.charge.formula}},
  \code{\link{get.isotopes.pattern}},
  \code{\link{isvalid.formula}},
  \code{\link{generate.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
\references{
  A parallel effort to expand the Chemistry Development Kit:
  \url{http://cdk.sourceforge.net}
}
