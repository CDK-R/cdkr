\name{get.tpsa}
\alias{get.tpsa}
\alias{get.alogp}
\alias{get.xlogp}
\alias{get.volume}
\title{
	Commonly Used Molecular Descriptors
}
\description{
	These methods will return the value for the corresponding
	descriptors. While they can always be evaluated using
	\code{\link{eval.desc}}, they are common enough that separate
	functions are provided.
}
\usage{
get.tpsa(molecule)
get.alogp(molecule)
get.xlogp(molecule)
get.volume(molecule)
}
\arguments{
  \item{molecule}{A \code{jObjRef} representing an IAtomContainer object}
}
\details{
It's important to note that ALogP and XLogP assumes that the molecule
has explicit hydrogens. If the molecule is read from an SD file,
explicit H's are usually present. On the other hand, if the molecule
is obtained from a SMILES, explicit hydrogens must be added.

The molecular volume is calculated using a group contribution method
rather than the an analytical method. This allows to avoid the use of 
3D structures.
}
\value{
	Single numeric value representing TPSA, ALogP, XLogP or molecular volume.
}
\keyword{programming}
\seealso{
	\code{\link{eval.desc}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
