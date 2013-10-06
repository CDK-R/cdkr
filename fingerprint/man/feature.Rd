\name{feature-class}
\docType{class}
\alias{feature-class}

\title{Class "feature"}
\description{This class represents features - arbitrary alphanumeric sequences
  that are used to characterize molecular substructures (though there is no real
  restriction to molecules). A feature is associated with an integer count, 
  indicating the occurence of that feature in a molecule. The default value is 1.
}
\section{Objects from the Class}{
  Objects can be created by calls of the form \code{new("feature", ...)}.
}
\section{Slots}{
  \describe{
    \item{\code{feature}:}{Object of class \code{"character"} ~ The string representation of a feature }
    \item{\code{count}:}{Object of class \code{"integer"} ~ The occurence of the feature. Default is 1}
    \item{\code{.Data}:}{???}
  }
}

\section{Methods}{
  \describe{
    \item{count}{\code{signature(object = "feature")}: Return the count associated with the
      feature}
  }
}

\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\seealso{
  \code{\link{featvec-class}}
}

\examples{
  ## create a new feature
  f <- new("feature", feature='ABCD', count=as.integer(1))

  ## modify the feature string and the count
  feature(f) <- 'UXYZ'
  count(f) <- 10
}
\keyword{classes}
\keyword{logic}