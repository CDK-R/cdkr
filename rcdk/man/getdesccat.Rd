\name{get.desc.categories}
\alias{get.desc.categories}
\title{
  Get Descriptor Class Names
}
\description{
	This function returns the broad descriptor categories that are
	available. Examples include topolgical, geometrical and so
	on. You can use a specific category to avoid calculating all
	descriptors for a set of molecules and saves you having to
	select individual descriptors by hand.
}
\usage{
get.desc.categories()
}
\value{
  A character vector of descriptor category names
}
\seealso{
\code{\link{eval.desc}}, \code{\link{get.desc.names}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
