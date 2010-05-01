\name{get.smiles.parser}
\alias{get.smiles.parser}
\title{
	Get a SMILES Parser
}
\description{
	This function returns a reference to a SMILES parser
	object. If you are parsing multiple SMILES strings, it is
	preferable to create your own parser and supply it to
	\code{\link{parse.smiles}} rather than forcing that function
	to instantiate a new parser for each call
}
\usage{
get.smiles.parser()
}
\value{
  A \code{jobjRef} to a CDK \code{SmilesParser} object
}
\keyword{programming}
\seealso{
  \code{\link{get.smiles}},
  \code{\link{get.smiles.parser}},
  \code{\link{view.molecule.2d}}
}
\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
