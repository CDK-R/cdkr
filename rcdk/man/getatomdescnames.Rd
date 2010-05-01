\name{get.atomic.desc.names}
\alias{get.atomic.desc.names}
\title{
  Get the names of the available atomic descriptors
}
\description{
  The CDK implements a number of descriptors divided into three main
  groups - atomic, molecular and bond. This method returns the names
  of the available atomic descriptors.
}
\usage{
	get.atomic.desc.names(type = "all")
}
\arguments{
  \item{type}{A string which can be one of
"all", "topological", "geometrical" "hybrid", "constitutional",
"electronic", allowing you to choose atomic descriptors of specific
categories. The keyword "all" will return all available descriptors}
}
\value{
	A vector of fully qualified descriptor names.
}
\seealso{
\code{\link{eval.atomic.desc}}
\code{\link{get.desc.names}}
\code{\link{eval.desc}}
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
