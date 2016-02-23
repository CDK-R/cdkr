\name{parse.inchi}
\alias{parse.inchi}
\alias{inchi}
\title{
  Parse an InChI String into a Molecule Object
}
\description{
This method parses an InChI string in to a CDK IAtomContainer object and thus
requires the \code{rcdk} package to be installed.
}
\usage{
parse.inchi(inchis)
}
\arguments{
  \item{inchis}{A character vector or list of InChI strings}
}
\value{
  A list of IAtomContainer objects in the form of \code{jObjRef} instances. If any InChI strings
are malformed, the corresponding object is \code{NULL}	
}
\keyword{programming}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
