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
                                c("C",0,50),
                                c("H",0,50),
                                c("N",0,50),
                                c("O",0,50),
                                c("S",0,50)),
                              validation = FALSE,
                              charge = 0.0,
                              as.string=TRUE)
		 
}

\arguments{
  \item{mass}{The mass value from which to be generate the formulas.},
  \item{window}{The window accuracy in the same units as mass.},
  \item{elements}{Elements to take into account. If the vector for a given element contains 3 elements (in the case of \code{generate.formula}), the major isotope of the element is employed. If you want to specify an alternative isotope, specify the mass number as the fourth element in the vector. Thus, to specify, \code{C13}, you would use \code{c("C", 0, 50, 13)}. For the case of \code{generate.formula.iter}, specify the mass number, if desired, as the third element.}
  \item{validation}{TRUE, if the method should only generate valid
  formulas. If FALSE, nonsensical formulae my be generated which must
  be filtered out by the user},
  \item{charge}{The charge value of the formula.}
  \item{as.string}{If \code{TRUE} the formula is returned as a string, otherwise as
  a \code{IMolecularFormula} object}
 }
\value{
	List of \code{IMolecularFormula} objects or strings, representing molecular formulae. If no
	formulae can be generated an empty list is returned.
}
\examples{

mfSet <- generate.formula(18.03383,charge=1,
                          elements=list(c("C",0,50),c("H",0,50),c("N",0,50)))
for (i in mfSet) {
  print(i)
}

## Generate formulae using N15
mfSet <- generate.formula(18.03383, window=0.1, charge=1,
                          elements=list(c("C",0,50),c("H",0,50),c("N", 0, 50, 15)))
for (i in mfSet) {
  print(i)
}


mit <- generate.formula.iter(18.03383,charge=1,
                          elements=list(C=c("C", 0,50), H=c("H", 0,50), N=c("N", 0,50)))
hit <- itertools::ihasNext(mit)
while (itertools::hasNext(hit)) 
  print(iterators::nextElem(hit))

## Generate formulae using N15
mit <- generate.formula.iter(18.03383, window=0.1, charge=1,
                          elements=list(C=c("C", 0,50), H=c("H", 0,50), N=c("N", 0,50,15)))
hit <- itertools::ihasNext(mit)
while (itertools::hasNext(hit)) 
  print(iterators::nextElem(hit))			  

}
\keyword{programming}
\seealso{
  \code{\link{get.formula}},
  \code{\link{set.charge.formula}},
  \code{\link{get.isotopes.pattern}},
  \code{\link{isvalid.formula}}
}
\author{Miguel Rojas-Cherto (\email{miguelrojasch@yahoo.es})}
