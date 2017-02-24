\name{view.molecule.2d}
\alias{get.depictor}
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
get.depictor(width = 200, height = 200, zoom = 1.3, style = "cow", annotate = "off", abbr = "on",
             suppressh = TRUE, showTitle = FALSE, smaLimit = 100, sma = NULL) 
view.molecule.2d(molecule, ncol = 4, depictor = NULL)
view.image.2d(molecule, depictor = NULL)
copy.image.to.clipboard(molecule, depictor = NULL)
}
\arguments{
  \item{molecule}{If a single molecule is to be viewed this should be a
    reference to a \code{IAtomContainer} object. If multiple molecules
    are to be viewed this should be a \code{list} of such objects. If a
    character is specified then it is taken as the name of a file and
    the molecules are loaded from the file}
  \item{depictor}{A depiction object. If \code{NULL} then one with default settings is created}
  \item{ncol}{The number of columns if a grid is desired}
  \item{width}{The width of the image}
  \item{height}{The height of the image}
  \item{zoom}{Zoom factor}
  \item{style}{Depiction style. Possible values are 'cow', 'bow', 'wob', 'cob', 'nob'}
  \item{annotate}{Annotation style. By default no annotations are added. Possible values include 'number', 'mapidx', 'atomvalue', 'colmap'}
  \item{abbr}{Abbreviation style for functional groups. Possible values are 'groups', 'reagents', 'on'}
  \item{suppressh}{When \code{TRUE} show H's otherwise hide them}
  \item{showTitle}{When \code{TRUE} display title}
  \item{smaLimit}{How many SMARTS patterns should be highlighted?}
  \item{sma}{A string containing the SMARTS pattern to match}
}
\value{
\code{get.depictor} returns a depiction object that can be supplied to other methods.
\code{view.molecule.2d} and \code{copy.image.to.ckipboard} do not return anything. 
\code{view.image.2d} returns  an array of the dimensions height x width x channels, from the original 
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
  for the \code{view.molecule.2d} method (for a single molecule) and the 
\code{copy.image.to.clipboard} method. In the future, other view methods will also 
be accessible via this mechanism. While this allows OS X users to view molecules, it is
slow due to invoking a new process.

  The depictions will work fine (i.e., no need to shell out) on Linux and Windows.
  }
\examples{
m <- parse.smiles('c1ccccc1C(=O)NC')[[1]]

\dontrun{
dep <- get.depictor(width=200, height=200)
img <- view.image.2d(m, dep)
plot(1:10, 1:10, pch=19)
rasterImage(img, 0,8, 2,10)

dep$setHeight(as.integer(400))
dep$setWidth(as.integer(400))
copy.image.to.clipboard(m,d) ## Paste into Word

}
}
\seealso{
  \code{\link{view.table}}, \code{\link{rasterImage}}, \code{\link{readPNG}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
