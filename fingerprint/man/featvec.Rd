\name{featvec-class}
\docType{class}
\alias{featvec-class}
\alias{distance,featvec,featvec,missing-method}
\alias{distance,featvec,featvec,character-method}
\alias{length,featvec-method}

\title{Class "featvec"}
\description{This class represents feature vector style fingerprints, where, rather than
a bit string, the fingerprint is represented as a sequence of (signed) integers or strings.
Each element of the collection is a representation of a structural feature. For cases where the
features are integers, this usually corresponds to a hash of the original feature string.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("featvec", ...)}.
In contrast to traditional binary fingerprints, operations on feature vectors
are slightly different and essentially correspond to operations on sets. Thus 
the logical and (&) would correspond to the union of the two feature vectors.
}
\section{Slots}{
	 \describe{
    \item{\code{features}:}{Object of class \code{"character"} ~~ A vector
      containing the numeric or character features. Numeric features are treated
      as character strings }
    \item{\code{provider}:}{Object of class \code{"character"} ~~
      Indicates the source of the fingerprint. Can be useful to keep
      track of what software generated the fingerprint.}
    \item{\code{name}:}{Object of class \code{"character"} ~~
      The name associated with the fingerprint. If not name is available
    this gets set to an empty string}
  }
}
\section{Methods}{
  \describe{
    \item{distance}{\code{signature(fp1 = "featvec", fp2 = "featvec", method = "missing")}: ... }
    \item{distance}{\code{signature(fp1 = "featvec", fp2 = "featvec", method = "character")}: ... }
    \item{as.character}{\code{signature(fp = "featvec")}: ... }
    \item{length}{\code{signature(fp = "featvec")}: ... }
    \item{show}{\code{signature(fp = "featvec")}: ... }
}
}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\seealso{
  \code{\link{fp.read}}, \code{\link{fp.read.to.matrix}}
  \code{\link{fp.sim.matrix}}, \code{\link{fp.to.matrix}},
  \code{\link{fp.factor.matrix}}
  \code{\link{random.fingerprint}}, \code{\link{featvec.to.binaryfp}}
}
 
\keyword{classes}
\keyword{logic}