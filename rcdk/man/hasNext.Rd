\name{hasNext}
\alias{hasNext}
\alias{hasNext.iload.molecules}
\title{Does This Iterator Have A Next Element}
\description{
  \code{hasNext} is a generic function that indicates if the iterator
  has another element.
}
\usage{
hasNext(obj, \dots)

\method{hasNext}{iload.molecules}(obj, \dots)
}
\arguments{
  \item{obj}{an iterator object.}
  \item{\dots}{additional arguments that are ignored.}
}
\value{
  Logical value indicating whether the iterator has a next element. In the context
  of reading a structure file, this indicates whether there are more molecules to read
}
\seealso{
\code{\link{iload.molecules}}
}
\keyword{methods}
