\name{get.desc.names}
\alias{get.desc.names}
\title{
  Get Descriptor Class Names
}
\description{
  The CDK implements a number of descriptors divided into three main
  groups - atomic, molecular and bond. Currently the package will only
  evaluate molecular descriptors. This function returns the class
  names of the available descriptors, which can then be used to
  calculate descriptors for a specific molecule.

  By default all available descriptor class names are
  returned. However it is possible to specify that a subset of the
  descriptors should be considered. The subset is specified by keyword
  and can be one of: topological, geometrical,hybrid, constitutional,
  protein, electronic.
}
\usage{
get.desc.names(type = "all")
}
\arguments{
	\item{type}{Indicates which subset of molecular descriptors
  should be considered}
}
\value{
  A character vector of descriptor class names
}
\seealso{
\code{\link{eval.desc}}, \code{\link{get.desc.categories}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
