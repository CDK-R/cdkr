\name{count-methods}
\docType{methods}

\alias{count-methods}
\alias{count}
\alias{count,feature-method}

\alias{count<--methods}
\alias{count<-}
\alias{count<-,feature,numeric-method}

\title{Get or Set Count of Occurence of a Feature}
\description{
  Get or set the count of occurence associated with a
  \code{\link{feature-class}} object. The default value for the getter
  (as defined in the prototype) is 1.
}

\section{Methods}{
  \describe{
    \item{\code{signature(object = "feature")}}{Return the count associated with the
      feature object}
    \item{\code{signature(x = "feature", value = "numeric")}}{Set the count associated with the
      feature object}
  }
}

\usage{
\S4method{count}{feature}(object)
\S4method{count}{feature,numeric}(x) <- value
}
\arguments{
  \item{object}{
    An object of class \code{\link{feature-class}}
  }
  \item{x}{
    An object of class \code{\link{feature-class}}
  }
  \item{value}{
    A numeric (which will be coerced to \code{integer}) indicating the
    count associated with the feature
  }
}
\value{
  An integer representing count of occurence of the feature
}
\keyword{programming}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
