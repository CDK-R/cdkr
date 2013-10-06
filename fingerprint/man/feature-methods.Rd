\name{feature-methods}
\docType{methods}

\alias{feature}
\alias{feature-methods}
\alias{feature,feature-method}

\alias{feature<--methods}
\alias{feature<-}
\alias{feature<-,feature,character-method}

\title{Get or Set the Character String Representing the Feature}
\description{
  Get or set the character string representing a feature of a 
  \code{\link{feature-class}} object. The default value for the getter
  (as defined in the prototype) is the empty string.
}

\section{Methods}{
  \describe{
    \item{\code{signature(object = "feature")}}{Return the feature associated with the
      feature object}
    \item{\code{signature(x = "feature", value = "character")}}{Set the feature associated with the
      feature object}
  }
}

\usage{
\S4method{feature}{feature}(object)
\S4method{feature}{feature,character}(x) <- value
}

\arguments{
  \item{object}{
    An object of class \code{\link{feature-class}}
  }
  \item{x}{
    An object of class \code{\link{feature-class}}
  }
  \item{value}{
    The character string to replace the current feature string with
  }
}
\value{
  An character string representing the feature
}
\keyword{programming}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
