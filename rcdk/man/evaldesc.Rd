\name{eval.desc}
\alias{eval.desc}
\title{
  Evaluate a Molecular Descriptor
}
\description{
  The CDK implements a number of descriptors divided into three main
  groups - atomic, molecular and bond. This method evaluates the
  specified molecular  descriptor(s) for a molecule
}
\usage{
eval.desc(molecules, which.desc, verbose=FALSE)
}
\arguments{
  \item{molecules}{A single \code{IAtomContainer} object or a  \code{list} of references to CDK
  \code{IAtomContainer} objects}
  \item{which.desc}{The fully qualified class name of the descriptor
  to evaluate or a vector such names}
  \item{verbose}{If TRUE, progress will be written to the screen,
  otherwise the function performs silently}
}
\examples{
smiles <- c('CCC', 'c1ccccc1', 'CC(=O)C')
mols <- sapply(smiles, parse.smiles)

dnames <- get.desc.names('constitutional')
descs <- eval.desc(mols, dnames, verbose=TRUE)
}
\value{
	A \code{data.frame} is returned. For a single molecule it will
	have one row, for multiple molecules it will have the 
	number of rows equal to the number of molecules
}
\seealso{
\code{\link{get.desc.names}}
\code{\link{get.desc.categories}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
