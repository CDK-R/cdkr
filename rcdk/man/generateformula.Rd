\name{generate.formula}
\alias{generate.formula}
\alias{generate.formula.iter}
\title{
	Generate molecular formulae given a target mass and a set of elements and counts.
}
\description{
	These functions generate a list of \code{cdkFormula} objects or strings given a mass and a set
	of elements and their possible counts (specified as a range). \code{generate.formula.iter}
	employs recently updated code making it much faster than \code{generate.formula}.

	In addition, \code{generate.formula.iter} returns an iterator, using which very large
	sets of formulae can be generated without excessive memory consumption. By default this
	method returns molecular formulae as strings, rather than \code{cdkFormula} objects. By default
	this method does not perform any validation, and even if \code{validation = TRUE} no validation
	is performed. \code{generate.formula} can perform validation, but this results in significantly
	slower run times.
}
\usage{
generate.formula(mass, window=0.01, elements=list(c("C",0,50),c("H",0,50),
                                                  c("N",0,50),c("O",0,50),
                                                  c("S",0,50)),
                 validation=FALSE, charge=0.0)
generate.formula.iter(mass, window = 0.01,
                              elements = list(
                                C=c(0,50),
                                H=c(0,50),
                                N=c(0,50),
                                O=c(0,50),
                                S=c(0,50)),
                              validation = FALSE,
                              charge = 0.0,
                              as.string=TRUE)
		 
}

\arguments{
  \item{mass}{The mass value from which to be generate the formulas.},
  \item{window}{The window accuracy in the same units as mass.},
  \item{elements}{Elements to take into account.},
  \item{validation}{TRUE, if the method should only generate valid
  formulas. If FALSE, nonsensical formulae my be generated which must
  be filtered out by the user},
  \item{charge}{The charge value of the formula.}
  \item{as.string}{If \code{TRUE} the formula is returned as a string, otherwise as
  a \code{IMolecularFormula} object}
 }
\value{
	List of \code{IMolecularFormula} objects or strings, representing molecular formulae
}
\examples{
mfSet <- generate.formula(18.03383,charge=1,
                          elements=list(c("C",0,50),c("H",0,50),c("N",0,50)))
for (i in mfSet) {
  print(i)
}

mit <- generate.formula.iter(18.03383,charge=1,
                          elements=list(elements=list(C=c(0,50), H=c(0,50), N=c(0,50))))
hit <- ihasNext(it)
while (hasNext(hit)) 
  print(nextElem(hit))			  
}
\keyword{programming}
\seealso{
  \code{\link{get.formula}},
  \code{\link{set.charge.formula}},
  \code{\link{get.isotopes.pattern}},
  \code{\link{isvalid.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
