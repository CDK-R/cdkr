\name{get.aid.by.cid}
\alias{get.aid.by.cid}
\title{
Get Assay ID Based on Compound Activity	
}
\description{
This function allows you to identify PubChem assays in which a
compound, specified by CID, has been tested in. The method uses
the PubChem Power User Gateway (PUG) and as a result can be slow.

The function can be used to identify assays in which the CID is
active, inactive or simply the assays in which it 
has been tested. 
}
\usage{
get.aid.by.cid(cid, type="tested", quiet=TRUE) 
}
\arguments{
  \item{cid}{A single compound ID}
  \item{type}{What type of query should be performed. Valid values are
  'active', 'inactive', 'tested'}
  \item{quiet}{If \code{FALSE}, output is verbose}
}
\value{
  If the \code{type} argument was one of 'active', 'inactive', or 
  'tested' a numeric vector of assay IDs. 

   In case an invalid CID was specified or the query failed, \code{NULL} is returned.
}
\seealso{
  \code{\link{get.assay}}
}
\keyword{programming}

\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\concept{PubChem}
\concept{pubchem}
\concept{compound}

