\name{load.molecules}
\alias{load.molecules}
\alias{iload.molecules}
\title{
  Load Molecular Structures From Disk
}
\description{
The CDK can read a variety of molecular structure formats. This function
encapsulates the calls to the CDK API to load a structure given its filename
}
\usage{
load.molecules(molfiles=NA, aromaticity = TRUE, typing = TRUE, isotopes = TRUE, verbose=FALSE)
iload.molecules(molfile, type="smi", aromaticity = TRUE, typing = TRUE, isotopes = TRUE)
}
\arguments{
  \item{molfiles}{A \code{character} vector of filenames. Note that the full
  path to the files should be provided. URL's can also be used as
  paths. In such a case, the URL should start with "http://"}
  \item{molfile}{A string containing the filename to load. Must be a local file}
  \item{type}{Indicates whether the input file is SMILES or SDF. Valid values are
  "smi" or "sdf"}
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
  \code{load.molecules} returns a list of CDK \code{Molecule} objects, which can be 
  used in other rcdk functions. 

  \code{iload.molecules} is an iterating version of the loader and is applicable for
  large SMILES or SDF files. In contrast to \code{load.molecules} this does not load
  all the molecules into memory at one go, and as a result lets you process arbitrarily
  large structure files. 			 
}
\details{
Note that if molecules are read in from formats that do not have rules for
handling implicit hydrogens (such as MDL MOL), the molecule will not have
implicit or explicit hydrogens. To add explicit hydrogens, make sure that the molecule
has been typed (this is \code{TRUE} by default for this function) and then call 
\code{\link{convert.implicit.to.explicit}}. On the other hand for a format 
such as SMILES, implicit or explicit hydrogens will be present.
}
\examples{
\dontrun{
moliter <- iload.molecules("big.sdf", type="sdf")
while(hasNext(moliter)) {
  mol <- nextElem(moliter)
  print(get.property(mol, "cdk:Title"))
}
}
}
\seealso{
  \code{\link{view.molecule.2d}}, \code{\link{convert.implicit.to.explicit}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
