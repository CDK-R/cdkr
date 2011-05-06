\name{get.total.charge}
\alias{get.total.charge}
\alias{get.total.formal.charge}
\alias{charge}
\title{
  Get the Total Charges for the Molecule
}
\description{
\code{get.total.charge} returns the summed partial charges for a molecule
and \code{get.total.formal.charge} returns the summed formal charges. Currently,
even if partial charges have not been assigned, the return value of \code{
get.total.charges} will be 0 and as a result may not match the total formal
charge on the molecules. This is a known issue in the CDK library
}
\usage{
get.total.charge(molecule)
get.total.formal.charge(molecule)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
}
\value{
A double value indicating the total partial charge or total formal
charge
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
