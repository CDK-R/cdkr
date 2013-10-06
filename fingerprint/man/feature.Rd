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
    \item{\code{feature}:}{Object of class \code{"character"} ~~ The string representation of a feature }
    \item{\code{count}:}{Object of class \code{"integer"} ~~ The occurence of the feature. Default is 1}
    \item{\code{.Data}:}{???}
  }
}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\seealso{
  \code{\link{featvec-class}}
}

\examples{
## make fingerprints
x <- new("fingerprint", nbit=128, bits=sample(1:128, 100))
y <- x
distance(x,y) # should be 1
x <- new("fingerprint", nbit=128, bits=sample(1:128, 100))
distance(x,y)
folded <- fold(x)

## binary operations on fingerprints
x <- new("fingerprint", nbit=8, bits=c(1,2,3,6,8))
y <- new("fingerprint", nbit=8, bits=c(1,2,4,5,7,8))
x & y
x | y
!x
}
\keyword{classes}
\keyword{logic}