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
get.sid.list(cid, quiet=TRUE, from.file=FALSE)
get.cid.list(sid, quiet=TRUE, from.file=FALSE)
}
\arguments{
  \item{cid}{A vector of one or more compound ID's}
  \item{sid}{A vector of one or more substance ID's}
  \item{quiet}{If \code{FALSE}, output is verbose}
  \item{from.file}{If \code{TRUE} then the first argument is considered
    to be the name of a file containing the XML data. If \code{FALSE}
    the first argument must be a sequence of compound ID's and the data
    will be downloaded from PubChem}
}
\value{
  A \code{list} object, the name of each element is the CID and the
  value is the SID's that are associated with the compound in question (or
  vice versa).
}
\details{Processing a large number of compound ID's can take a long
  time. For large numbers of CID's the resultant XML file can be many
  megabytes. This may take a long time to download. After download it
  takes approximate 60 sec to process a 23MB data file.

  It should also be noted that the data files are downloaded using the R
  interface to Curl. In addition, the PubChem servers do not allow very
  large query URL's. This limits the number of compound ID's that can be
  directly pulled of the PubChem servers to about 1000
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

