\name{view.molecule.2d}
\alias{view.molecule.2d}
\alias{view.image.2d}
\alias{copy.image.to.clipboard}
\alias{depict}
\title{
  View and Copy 2D Structure Diagrams
}
\description{
The CDK is capable of generating 2D structure diagrams. These methods
allow one to view 2D structure diagrams. Depending on the method called
a Swing JFrame is displayed which allows resizing of the image or a
raster image (derived from a PNG byte stream) is is returned, which can 
be viewed using \code{\link{rasterImage}}. It is also possible to copy
a 2D depiction to the system clipboard, which can then be pasted into 
various external applications.
}
\usage{
view.molecule.2d(molecule, ncol = 4, cellx = 200, celly = 200)
view.image.2d(molecule, width = 200, height = 200)
copy.image.to.clipboard(molecule, width = 200, height = 200)
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
  \item{width}{The width of the image}
  \item{height}{The height of the image}
}
\value{
\code{view.molecule.2d} and \code{copy.image.to.ckipboard} do not return anything. 
\code{view.image.2d} returns 
an array of the dimensions height x width x channels, from the original
PNG version of the 2D depiction. 	
}
\details{
  For the case of \code{view.molecule.2d}, if a \code{jobjRef} is passed it should be a reference to an
  \code{IAtomContainer} object. In case the first argument is of class
  character it is assumed to be a file and is loaded by the function.
  
  This function can be used to view a single molecule or multiple
  molecules. If a \code{list} of molecule objects is supplied the
  molecules are displayed as a grid of 2D viewers. In case a file is
  specified, it will display a single molecule or multiple molecules
  depending on how many molecules are loaded.

  For \code{view.image.2d}, the image can be viewed via \code{\link{rasterImage}}.

  \code{copy.image.to.clipboard} copies the 2D depiction to the system clipboard in 
  PNG format. You can then paste into other applications.

  Due to event handling issues, the depiction will show on OS X, but
  the window will be unresponsive. Also copying images to the clipboard will not work.
  As a result, on OS X we make use of a standalone
  helper that is run via the \code{system} command. Currently, this is supported
  for the \code{\link{view.molecule.2d}} method (for a single molecule) and the 
\code{\link{copyy.image.to.clipboard}} method. In the future, other view methods will also 
be accessible via this mechanism. While this allows OS X users to view molecules, it is
slow due to invoking a new process.

  The depictions will work fine (i.e., no need to shell out) on Linux and Windows.
  }
\examples{
m <- parse.smiles('c1ccccc1C(=O)NC')[[1]]
\dontrun{
img <- view.image.2d(m, 100,100)
plot(1:10, 1:10, pch=19)
rasterImage(img, 0,8, 2,10)
}
}
\seealso{
  \code{\link{view.table}}, \code{\link{rasterImage}}, \code{link{readPNG}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
