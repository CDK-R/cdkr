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
if one or more partial charges are unset, the function simply returns
the sum of formal charges (via \code{get.total.formal.charge}). This is slightly
different from how the CDK evaluates the total charge of a molecule (via
AtomContainerManipulator.getTotalCharge()), but is in line with how OEChem
determines net charge on a molecule.

In general, you will want to use the \code{get.total.charge} function.
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
