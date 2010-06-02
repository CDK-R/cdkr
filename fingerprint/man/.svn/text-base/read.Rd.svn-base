\name{fp.read, fp.read.to.matrix}
\alias{fp.read}
\alias{fp.read.to.matrix}
\title{
    Functions to Read Fingerprints From Files
}
\description{
\code{fp.read} reads in a set of fingerprints from a file. Fingerprint 
output from the CDK, MOE and BCI can be handled.

Each fingerprint is represented as a \code{fingerprint} object.
\code{fp.read} returns a \code{list} structure, each element being a
\code{fingerprint} object.

\code{fp.read.to.matrix} is a utility function that reads the fingerprints directly to
matrix form (columns are the bit positions and the rows are the objects whose fingerprints
have been evaluated)
}

\usage{
fp.read(f='fingerprint.txt', size=1024, lf=cdk.lf, header=FALSE)
fp.read.to.matrix(f='fingerprint.txt', size=1024, lf=cdk.lf, header=FALSE)
}
\arguments{
  \item{f}{
    File containing the fingperprints
  }
  \item{size}{
    The bit length of the fingerprints being considered
  }
  \item{lf}{
    A line reading function that parses a single line from
    a fingerprint file. Currently, three such functions are provided
    that parse the fingerprints from the output of the CDK, MOE and the
    BCI toolkit,  respectively.
  }
  \item{header}{
    Indicates whether the first line of the fingerprint file is
    a header line
  }
}
\seealso{
  \code{\link{cdk.lf}},
  \code{\link{moe.lf}},
  \code{\link{bci.lf}}
}
\value{
  A \code{list} or \code{matrix} of fingerprints
}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
\keyword{logic}



