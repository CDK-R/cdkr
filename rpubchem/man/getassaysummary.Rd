\name{get.assay.summary}
\alias{get.assay.summary}
\title{
  Get a PubChem Bio-Assay Summary
}
\description{
  Obtain the assay summary for a given assay id.
}
\details{
  The Pubchem assay summary has a number of sections, with each section seperated into
  chunks. The method will concatenate all chunks for a given
  section. 
}
\usage{
get.assay.summary(aid)
}
\arguments{
  \item{aid}{An assay ID}
}
\value{
  A list with three elements
  \itemize{
    \item{Comment}
    \item{Protocol}
    \item{Description}
  }
}
\seealso{
\code{\link{get.assay}}, \code{\link{get.assay.desc}}, \code{\link{find.assay.id}}
}
\keyword{programming}

\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\concept{PubChem}
\concept{pubchem}
\concept{assay data}

