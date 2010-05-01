\name{remove.property}
\alias{remove.property}
\title{
  Remove A Property From a Molecule
}
\description{
  This function removes a keyed property from a molecule object. This
  deletes the key and its value from the molecule
}
\usage{
remove.property(molecule, key)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
  \item{key}{A string naming the property}
}
\value{
  None
}
\keyword{programming}
\seealso{
  \code{\link{get.property}},
  \code{\link{set.property}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
