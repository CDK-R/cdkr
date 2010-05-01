\name{view.molecule.2d}
\alias{view.molecule.2d}
\title{
  View 2D Structure Diagrams
}
\description{
The CDK is capable of generating 2D structure diagrams. This function
encapsulates the calls to the API to generate individual structure
diagrams as well as grids of 2D structures.
}
\usage{
view.molecule.2d(molecule, ncol = 4, cellx = 200, celly = 200)
}
\arguments{
  \item{molecule}{If a single molecule is to be viewed this should be a
    reference to a \code{IAtomContainer} object. If multiple molecules
    are to be viewed this should be a \code{list} of such objects. If a
    character is specified then it is taken as the name of a file and
    the molecules are loaded from the file}
  \item{ncol}{The number of columns if a grid is desired}
  \item{cellx}{The width of the grid cells}
  \item{celly}{The height of the grid cells}
}
\value{
  Nothing
}
\details{
  If a \code{jobjRef} is passed it should be a reference to an
  \code{IAtomContainer} object. In case the first argument is of class
  character it is assumed to be a file and is loaded by the function.
  
  This function can be used to view a single molecule or multiple
  molecules. If a \code{list} of molecule objects is supplied the
  molecules are displayed as a grid of 2D viewers. In case a file is
  specified, it will display a single molecule or multiple molecules
  depending on how many molecules are loaded.

  Due to event handling issues, the depiction will show on OS X, but
  the window will be unresponsive. The depictions will work fine on
  Linux and Windows.
  }
\seealso{
  \code{\link{view.table}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
