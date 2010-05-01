\name{load.molecules}
\alias{load.molecules}
\title{
  Load Molecular Structure From Disk
}
\description{
The CDK can read a variety of molecular structure formats. This function
encapsulates the calls to the CDK API to load a structure given its filename
}
\usage{
load.molecules(molfiles=NA, aromaticity = TRUE, typing = TRUE, isotopes = TRUE, verbose=FALSE)
}
\arguments{
  \item{molfiles}{A \code{character} vector of filenames. Note that the full
  path to the files should be provided. URL's can also be used as
  paths. In such a case, the URL should start with "http://"}
  \item{aromaticity}{If \code{TRUE} then aromaticity detection is
  performed on all loaded molecules. If this fails for a given
  molecule, then the molecule is set to NA in the return list}
  \item{typing}{If \code{TRUE} then atom typing is
  performed on all loaded molecules. The assigned types will be CDK
  internal types. If this fails for a given
  molecule, then the molecule is set to NA in the return list}
  \item{isotopes}{If \code{TRUE} then atoms are configured with isotopic masses}
  \item{verbose}{If TRUE, output (such as file download progress) will
  be bountiful}
}
\value{
  A list of CDK \code{Molecule} objects, which can be used in other rcdk 
  functions
}
\seealso{
  \code{\link{view.molecule.2d}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
