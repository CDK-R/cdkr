\name{get.sid.list}
\alias{get.sid.list}
\alias{get.cid.list}
\title{
  Get PubChem Substance ID's Associated With A Compound and Vice Versa
}
\description{
  Each unique compound is associated with a number of substances. Given
  a CID it is possible to determine the associated substance ID's. Conversely
  given a SID it is useful to identify all CIDs that are associated with it
}
\usage{
get.sid.list(cid, quiet=TRUE)
get.cid.list(sid, quiet=TRUE)
}
\arguments{
  \item{cid}{A single compound ID}
  \item{sid}{A single substance ID}
  \item{quiet}{If \code{FALSE}, output is verbose}
}
\value{
 Depending on whether the input was a CID or SID, the return value is a numeric vector of
SID's or a single numeric CID, respectively.
}
\details{
Even though PUG REST allows one to specify multiple input ID's these methods operate on
single identifiers, allowing the user to parallelize multiple queries. In addition, this
approach allows the package to cache results for individual input identifiers
}

\seealso{
  \code{\link{get.cid}},
  \code{\link{get.sid}},
  \code{\link{get.assay}}
}
\keyword{programming}

\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\concept{PubChem}
\concept{pubchem}
\concept{compound}

