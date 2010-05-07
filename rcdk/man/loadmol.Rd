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
  functions. 
}
\details{
Note that if molecules are read in from formats that do not have rules for
handling implicit hydrogens (such as MDL MOL), the molecule will not have
implicit or explicit hydrogens. To add explicit hydrogens, make sure that the molecule
has been typed (this is \code{TRUE} by default for this function) and then call 
\code{\link{convert.implicit.to.explicit}}. On the other hand for a format 
such as SMILES, implicit or explicit hydrogens will be present.
}
\seealso{
  \code{\link{view.molecule.2d}}, \code{\link{convert.implicit.to.explicit}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
