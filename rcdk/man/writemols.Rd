\name{write.molecules}
\alias{write.molecules}
\title{
  Write Molecules To Disk
}
\description{
  This function writes one or more molecules to an SD file on disk,
  which can be of the single- or multi-molecule variety. In
  addition, if the molecule has keyed properties, they can also be
  written out as SD tags.
}
\usage{
write.molecules(mols, filename, together=TRUE, write.props=FALSE)
}
\arguments{
  \item{mols}{A \code{list} of Java objects of class \code{IAtomContainer}}
  \item{filename}{The name of the SD file to write. Note that if
    \code{together} is FALSE then this argument is taken as a prefix for
    the name of the individual files}
  \item{together}{If \code{TRUE} then all the molecules are written to a
    single SD file. If \code{FALSE} each molecule is written to an
    individual file}
  \item{write.props}{Should keyed properties be included in the SD file output}
}
\details{
  This function can be used to write a single SD file containing
  multiple molecules. In case individual SD files are desired the
  \code{together} argument can be set ot \code{FALSE}. In this case, the
  value of \code{filename} is used as a prefix, to which a numeric
  identifier and the suffix of ".sdf" is appended. In case, a single
  molecule is to be written to disk, simply specify the filename and use
  the default value of \code{together}
  }
\value{
 The value of the property
}
\keyword{programming}
\seealso{
  \code{\link{load.molecules}},
  \code{\link{set.property}},
  \code{\link{get.property}},  
  \code{\link{remove.property}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
