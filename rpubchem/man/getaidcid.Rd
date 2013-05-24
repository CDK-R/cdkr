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
active, inactive, discrepant in, or simply the assays in which it 
has been tested. 

However, since the query can be slow, it is useful 
have the raw data. In such a case, one can get an indicator matrix
which can be processed to identify assays in which the compound
are active, inactive, etc.
}
\usage{
get.aid.by.cid(cid, type="raw", quiet=TRUE) 
}
\arguments{
  \item{cid}{A single compound ID}
  \item{type}{What type of query should be performed. Valid values are
  'active', 'inactive', 'discrepant', 'tested' or 'raw'.}
  \item{quiet}{If \code{FALSE}, output is verbose}
}
\value{
  If the \code{type} argument was one of 'active', 'inactive', 'discrepant' or 
  'tested' a numeric vector of assay IDs. If 'raw' was specifiec, a binary matrix
  is returned with the number of rows equal to the number of assays the compound
  was  tested in and 4 columns - aid, active, inactive, discrepant. If a row has a 
 a 1 in columns 2 to 4, it indicates that the compound is either active, inactive
or discrepant.

   In case an invalid CID was specified or the query failed, \code{NULL} is returned.
}
\details{Since the method employs PUG, it is rather slow. In addition it can also
fail intermittently. In general, as long as the CID is correctly specified, a pause
between subsequent calls usually allows the query to successfully complete}

\seealso{
  \code{\link{get.assay}}
}
\keyword{programming}

\author{Rajarshi Guha \email{rguha@indiana.edu}}
\concept{PubChem}
\concept{pubchem}
\concept{compound}

