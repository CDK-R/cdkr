\name{find.assay.id}
\alias{find.assay.id}
\title{
  Search for Assay ID's
}
\description{
  PubChem allows one to obtain the ID's of bio-assays that match a
  search string. This function uses the Entrez interface to supply a
  query string and return the ID's of matching bio-assays
}
\usage{
find.assay.id(query, quiet=TRUE)
}
\arguments{
  \item{query}{A character string containing the query}
  \item{quiet}{If \code{FALSE} the output is verbose}
}
\value{
  A numeric vector containing the ID's that match the search query
}
\examples{
\dontrun{
## find assay ID's related to yeast
aids <- find.assay.id('yeast')

## get the description of the first 10 assays
descs <- lapply( lapply(as.list(aids[1:10]), get.assay.desc), function(x)
x$assay.desc )
}
}
\seealso{
\code{\link{get.assay.desc}}, \code{\link{get.assay}}
}
\keyword{programming}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\concept{PubChem}
\concept{pubchem}
\concept{assay id}
