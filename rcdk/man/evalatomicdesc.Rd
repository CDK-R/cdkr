\name{eval.atomic.desc}
\alias{eval.atomic.desc}
\title{
  Evaluate an Atomic Descriptor
}
\description{
  The CDK implements a number of descriptors divided into three main
  groups - atomic, molecular and bond. This method evaluates the
  specified atomic  descriptor(s) for a molecule
}
\usage{
eval.atomic.desc(molecule, which.desc, verbose=FALSE)
}
\arguments{
  \item{molecule}{A  reference to a CDK \code{IAtomContainer} object}
  \item{which.desc}{The fully qualified class name of the descriptor
  to evaluate or a vector such names}
  \item{verbose}{If TRUE, progress will be written to the screen,
  otherwise the function performs silently}
}
\value{
	A \code{data.frame} is returned.
}
\seealso{
\code{\link{get.atomic.desc.names}}
\code{\link{get.desc.names}}
\code{\link{eval.desc}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
