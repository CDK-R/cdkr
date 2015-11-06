\name{get.synonyms}
\alias{get.synonyms}
\title{
  Get PubChem Compound ID's and Synonyms
}
\description{
  PubChem allows one to obtain the compound ID's and synonyms of
  compounds that match a search string. This function uses the PubChem
  Power User Gateway (PUG) REST API to supply a character vector of one
  or more compound names and return the compound ID's and synonyms of
  matching compounds. Additional information on compounds can be
  obtained using the \code{\link{get.cid}} function.
}
\usage{
get.synonyms(name, quiet=TRUE)
}
\arguments{
  \item{name}{A vector of one or more compound names}
  \item{quiet}{If \code{FALSE}, output is verbose}
}
\value{
  A \code{data.frame} with 4 columns:
    \item{Name}{The compound name provided}
    \item{CID}{The compound ID}
    \item{Synonym}{Synonyms associated with the compound ID}
    \item{CAS}{Logical indicating whether the synonym is a CAS RN}
}
\details{Processing a large number of compounds can take a long time.
  The PUG REST API is not designed for very large volumes (millions)
  of requests. In order to avoid overloading the PubChem servers, this
  function is limited to 5 requests per second.
}

\seealso{
  \code{\link{get.cid}}
}
\keyword{programming}

\author{John Buonagurio \email{jbuonagurio@exponent.com}}
\concept{PubChem}
\concept{pubchem}
\concept{compound}

